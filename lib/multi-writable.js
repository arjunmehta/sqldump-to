const { spawn } = require('child_process');
const stream = require('stream');
const { writeToFileDir } = require('./util/fs');
const { SQLBuffer, BUFFERS } = require('./util/buffer');


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


function sendToWorker(worker, obj, cb = () => {}) {
  const str = typeof obj === 'string' ? obj : JSON.stringify(obj);
  const configBuffer = Buffer.from(`${str}\n`);

  worker.stdin.write(configBuffer, cb);
}


// Primary Class Definition

class MultiWriteable extends stream.Writable {
  constructor(config = {}) {
    super();

    const {
      numWorkers,
      outputDir,
      schemaFormat,
    } = Object.assign({}, config);

    this.buffer = new SQLBuffer();

    this.tables = {};
    this.currentTable = null;

    this.outputDir = outputDir;
    this.schemaFormat = schemaFormat;

    this.numWorkers = parseInt(numWorkers, 10);
    this.workers = [];
    this.readyWorkers = [];

    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = spawn('node',
        [`${__dirname}/worker`], {
          detached: true,
          stdio: ['pipe', 'inherit', 'inherit'],
        });

      worker
        .on('error', (err) => {
          throw err;
        })
        .on('exit', (exitCode) => {
          if (exitCode !== 0) {
            console.error(`Worker ${i}-PID ${worker.pid} exited with code: ${exitCode}`);
          }
        });

      this.workers[i] = worker;
      this.readyWorkers[i] = worker;
    }

    this.sendConfig();
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

    const positions = [indexOfCreate, indexOfInsert, indexOfUse].filter(val => val !== -1);
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
    const contents = this.buffer.getContentBetweenNext(VALUES_BUFF, INSERT_INTO_BUFF);

    if (contents === undefined) {
      this.next();
    } else {
      this.setTable(cleanVarName(contents));
      this.continueInsert();
    }
  }

  continueInsert() {
    const writes = [];
    let row;
    let worker;
    let queueItem = this.buffer.getNextCommandParenSet();

    while (
      queueItem
      && queueItem !== COMMAND_EXEC_BUFF
      && this.readyWorkers.length
    ) {
      worker = this.readyWorkers.pop();
      row = `[${queueItem}]`;
      writes.push(this.writeToNextAvailableWorker(worker, row));

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
    const tableString = this.buffer
      .getContentBetweenNext(CREATE_TABLE_BUFF, BRACKET_OPEN_BUFF, { moveToEnd: true });

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
        this.sendSchema(schema);

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


  // //////////////////////////////////////////////////////
  // Worker Methods

  writeToNextAvailableWorker(worker, row) {
    const numWorkersAvailable = this.readyWorkers.length;

    return new Promise((resolve) => {
      let callNext = resolve;

      if (numWorkersAvailable) {
        callNext = () => {};
        resolve();
      }

      sendToWorker(worker, row, () => {
        this.readyWorkers.push(worker);
        callNext();
      });
    });
  }

  sendConfig() {
    const workerConfig = {
      outputDir: this.outputDir,
      totalWorkers: this.workers.length,
    };

    this.workers
      .forEach((worker, i) => {
        const config = Object.assign({
          workerPart: i,
        }, workerConfig);

        sendToWorker(worker, { config });
      });
  }

  sendSchema(schema) {
    this.workers
      .forEach((worker) => {
        sendToWorker(worker, { schema });
      });
  }
}


module.exports = MultiWriteable;
