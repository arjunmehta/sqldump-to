const stream = require('stream');

const WriteWorkerController = require('./write-worker-controller');
const { SQLBuffer, BUFFERS } = require('./sql-buffer');
const { writeToFileDir } = require('./util/fs');

const {
  BRACE_OPEN_BUFF,
  COMMAND_EXEC_BUFF,
  CREATE_TABLE_BUFF,
  INSERT_INTO_BUFF,
  USE_BUFF,
  VALUES_BUFF,
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
  return str.replace(/['"`]+/g, '').trim();
}

function startsWithAny(str, stringArray) {
  for (let i = 0; i < stringArray.length; i += 1) {
    if (str.startsWith(stringArray[i])) {
      return true;
    }
  }

  return false;
}

function buildSchema(commandContents) {
  const commands = commandContents.split('\n');
  const schema = [];
  const ignoreList = [
    'INDEX',
    'KEY',
    'FULLTEXT',
    'SPATIAL',
    'CONSTRAINT',
    'PRIMARY',
    'UNIQUE',
    'FOREIGN',
  ];

  commands.forEach((command) => {
    const cleanCommand = command.slice(0, -1).trim();

    if (cleanCommand && !startsWithAny(cleanCommand, ignoreList)) {
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

    this.databases = { default: { tables: {} } };
    this.currentDatabaseName = null;
    this.currentTableName = null;
  }

  get currentDatabase() {
    const databaseName = this.currentDatabaseName || 'default';
    return this.databases[databaseName];
  }

  // Handle New Data

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
    ].filter((val) => val !== -1);

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
        this.state = STATES.USE;
        this.runUseDatabase();
        break;
      default:
        this.state = null;
        this.next();
        break;
    }
  }

  // Handle Insert State

  switchCurrentTable(tableName, cb) {
    if (this.currentDatabase.tables[tableName]) {
      this.currentTableName = tableName;
      this.writeWorkers.sendSchema(this.currentDatabase.tables[tableName], cb);
    } else {
      throw new Error(`The schema for table '${tableName}' has not been set yet. Your dump needs a CREATE TABLE query.`);
    }
  }

  runInsert() {
    const contents = this
      .buffer
      .getContentBetweenNext(INSERT_INTO_BUFF, VALUES_BUFF, {
        moveToEnd: true,
      });

    if (contents === undefined) {
      this.next();
    } else if (this.currentTableName !== cleanVarName(contents)) {
      this.switchCurrentTable(cleanVarName(contents), () => {
        this.continueInsert();
      });
    } else {
      this.continueInsert();
    }
    // // console.log('Switching Table', cleanVarName(contents));
    // this.switchCurrentTable(cleanVarName(contents), () => {
    //   this.continueInsert();
    // });
  }

  continueInsert() {
    const queueItem = this.buffer.getNextCommandParenSet();

    if (!queueItem && this.buffer.isAtEnd) {
      return this.next();
    }

    if (queueItem === COMMAND_EXEC_BUFF) {
      this.buffer.clean();
      this.state = null;
      return this.determineState();
    }

    return this
      .writeWorkers
      .write(queueItem, () => {
        this.continueInsert();
      });
  }

  // Handle Use Database State

  switchCurrentDatabase(databaseName) {
    if (!this.databases[databaseName]) {
      this.databases[databaseName] = { tables: {} };
    }

    this.currentDatabaseName = databaseName;
  }

  runUseDatabase() {
    const contents = this
      .buffer
      .getContentBetweenNext(USE_BUFF, COMMAND_EXEC_BUFF, {
        moveToEnd: true,
      });

    if (contents === undefined) {
      this.next();
    } else {
      this.switchCurrentDatabase(cleanVarName(contents));
      this.runSeekEOL();
    }
  }

  // Handle Seek EOL State

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
      .getContentBetweenNext(CREATE_TABLE_BUFF, BRACE_OPEN_BUFF, {
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
          databaseName: this.currentDatabaseName,
          tableName,
          columns,
        };

        this.currentDatabase.tables[tableName] = schema;

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

  writeSchema({ tableName, columns, databaseName }) {
    const format = this.schemaFormat === true ? 'default' : this.schemaFormat;
    const baseDirectory = this.outputDir || './';
    const directory = databaseName ? `${baseDirectory}/${databaseName}` : baseDirectory;
    const filename = `${tableName}_schema.json`;
    let schemaColumns;

    if (format === 'default') {
      schemaColumns = columns;
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
