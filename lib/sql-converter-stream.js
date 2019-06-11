const stream = require('stream');

const WriteWorkerController = require('./write-worker-controller');
const { SQLBuffer, BUFFERS } = require('./sql-buffer');
const { writeToFileDir } = require('./util/fs');


const {
  INSERT_INTO_BUFF,
  VALUES_BUFF,
  COMMAND_EXEC_BUFF,
  BRACKET_OPEN_BUFF,
  CREATE_TABLE_BUFF,
  USE_BUFF,
} = BUFFERS;


// Constants

const STATES = {
  INSERT: 'Inserting Rows',
  USE: 'Use Database',
  CREATE: 'Creating Table',
  SEEKING_EOL: 'Seeking EOL',
};


// Helper Functions

function cleanVarName(str) {
  return str
    .replace(/['"`]+/g, '')
    .trim();
}

function buildSchema(commandContents) {
  const commands = commandContents.split('\n');
  const schema = [];

  commands.forEach((command) => {
    const cleanCommand = command.slice(0, -1).trim();
    const [firstChar] = cleanCommand;

    if (firstChar === '`' || firstChar === '\'' || firstChar === '"') {
      const [name, type] = cleanCommand.split(' ');
      const column = { name: cleanVarName(name), type };
      schema.push(column);
    }
  });

  return schema;
}


// Primary Class Definition

class SQLConverterStream extends stream.Writable {
  constructor(config = {
    numWorkers: 1,
    outputDir: null,
    schemaFormat: null,
  }) {
    super();

    Object.assign(this, config);

    this.buffer = new SQLBuffer();
    this.writeWorkers = new WriteWorkerController(config);

    this.tables = {};
    this.currentTable = null;

    this.writeWorkers.sendConfig();
  }

  _write(chunk, enc, next) {
    this.next = next;
    this.buffer.add(chunk);
    this.handleNewBuffer();
  }

  handleNewBuffer() {
    switch (this.state) {
      case STATES.INSERT:
        this.continueInsert();
        break;
      case STATES.USE:
        this.runUseDatabase();
        break;
      case STATES.CREATE:
        this.runReadSchema();
        break;
      case STATES.SEEKING_EOL:
        this.runSeekEOL();
        break;
      default:
        this.determineState();
        break;
    }
  }


  // Handle No State

  determineState() {
    const indexOfCreate = this.buffer.indexOf(CREATE_TABLE_BUFF, undefined, false);
    const indexOfInsert = this.buffer.indexOf(INSERT_INTO_BUFF, undefined, false);
    const indexOfUse = this.buffer.indexOf(USE_BUFF, undefined, false);

    const positions = [
      indexOfCreate,
      indexOfInsert,
      indexOfUse,
    ].filter(val => val !== -1);

    const nearest = Math.min(...positions);

    switch (nearest) {
      case indexOfCreate:
        this.state = STATES.CREATE;
        this.runReadSchema();
        break;
      case indexOfInsert:
        this.state = STATES.INSERT;
        this.runInsert();
        break;
      case indexOfUse:
        break;
      default:
        this.state = null;
        this.next();
        break;
    }
  }


  // Handle Insert State

  setTable(tableName) {
    if (this.tables[tableName]) {
      this.currentTable = tableName;
    } else {
      throw new Error(`The schema for table '${tableName}' has not been set yet. Your dump needs a CREATE TABLE query.`);
    }
  }

  runInsert() {
    const contents = this
      .buffer
      .getContentBetweenNext(VALUES_BUFF, INSERT_INTO_BUFF, {
        moveToEnd: true,
      });

    if (contents === undefined) {
      this.next();
    } else {
      this.setTable(cleanVarName(contents));
      this.continueInsert();
    }
  }

  continueInsert() {
    const writes = [];
    const { readyWorkers } = this.writeWorkers;
    let row;
    let worker;
    let queueItem = this.buffer.getNextCommandParenSet();

    while (
      queueItem
      && queueItem !== COMMAND_EXEC_BUFF
      && readyWorkers.length
    ) {
      worker = readyWorkers.pop();
      row = `[${queueItem}]`;
      writes.push(this.writeWorkers.writeToNextAvailableWorker(worker, row));

      queueItem = this.buffer.getNextCommandParenSet();
    }

    Promise
      .all(writes)
      .then(() => {
        if (!queueItem && this.buffer.isAtEnd) {
          return this.next();
        }

        if (queueItem === COMMAND_EXEC_BUFF) {
          this.buffer.clean();
          this.state = null;
          return this.determineState();
        }

        return this.continueInsert();
      })
      .catch((err) => {
        console.error(err);
      });
  }

  runSeekEOL() {
    const end = this.buffer.skipToEndOfCommand();

    this.buffer.clean();
    this.state = null;

    if (end === COMMAND_EXEC_BUFF) {
      this.determineState();
    } else if (!end) {
      this.state = STATES.SEEKING_EOL;
      this.next();
    }
  }


  // Handle Create Table State

  runReadSchema() {
    const tableString = this
      .buffer
      .getContentBetweenNext(CREATE_TABLE_BUFF, BRACKET_OPEN_BUFF, {
        moveToEnd: true,
      });

    if (tableString === undefined) {
      this.next();
    } else {
      const tableName = cleanVarName(tableString);
      const contents = this.buffer.getNextCommandParenSet();

      if (contents) {
        const createContents = contents.toString().trim();
        const columns = buildSchema(createContents);
        const schema = {
          name: tableName,
          columns,
        };

        this.tables[tableName] = schema;
        this.writeWorkers.sendSchema(schema);

        if (this.schemaFormat) {
          this.writeSchema(schema);
        }

        // Done processing Create Table command. Jump to end of line or as far as possible
        this.runSeekEOL();
      } else {
        this.next();
      }
    }
  }

  writeSchema(schema) {
    const format = this.schemaFormat === true ? 'default' : this.schemaFormat;
    const directory = this.outputDir || './';
    const filename = `${schema.name}_schema.json`;
    let schemaColumns;

    if (format === 'default') {
      schemaColumns = schema.columns;
    } else {
      const errorMessage = `Schema format '${format}' not supported yet.`;
      throw new Error(errorMessage);
    }

    writeToFileDir({
      directory,
      filename,
      content: JSON.stringify(schemaColumns, null, 2),
    });
  }
}


module.exports = SQLConverterStream;
