const { spawn } = require('child_process');
const stream = require('stream');


// Constants

const BRACKET_CLOSE_BUFF = Buffer.from(')');
const BRACKET_OPEN_BUFF = Buffer.from('(');
const COMMAND_EXEC_BUFF = Buffer.from(';');
const CREATE_TABLE_BUFF = Buffer.from('CREATE TABLE ');
const INSERT_INTO_BUFF = Buffer.from('INSERT INTO ');
const ESCAPE_CHAR_BUFF = Buffer.from('\\');
const STRING_OPENER_BUFF = Buffer.from('\'');
const VALUES_BUFF = Buffer.from(' VALUES ');

const BRACKET_CLOSE_OCTET = BRACKET_CLOSE_BUFF[0];
const BRACKET_OPEN_OCTET = BRACKET_OPEN_BUFF[0];
const COMMAND_EXEC_OCTET = COMMAND_EXEC_BUFF[0];
const ESCAPE_CHAR_OCTET = ESCAPE_CHAR_BUFF[0];
const STRING_OPENER_OCTET = STRING_OPENER_BUFF[0];

const STATES = {
  INSERT: 'Inserting Rows',
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
      workerConfig,
    } = Object.assign({}, config);

    this.tables = {};
    this.currentTable = null;

    this.workerConfig = workerConfig;
    this.numWorkers = parseInt(numWorkers, 10);
    this.workers = [];
    this.readyWorkers = [];

    // BufferState
    this.buffer = Buffer.from('');
    this.bufferPosition = 0;
    this.openBracketCount = 0;
    this.isWithinString = false;
    this.isEscaped = false;
    this.bracketStartPos = 0;
    this.bracketEndPos = 0;


    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = spawn('node',
        [`${__dirname}/worker`], {
          detached: true, stdio: ['pipe', 'inherit', 'inherit'],
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
    this.buffer = Buffer.concat([this.buffer, chunk]);
    this.handleNewBuffer();
  }

  handleNewBuffer() {
    switch (this.state) {
      case STATES.INSERT:
        this.continueInsert();
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
    const indexOfCreate = this.buffer.indexOf(CREATE_TABLE_BUFF, this.bufferPosition);
    const indexOfInsert = this.buffer.indexOf(INSERT_INTO_BUFF, this.bufferPosition);

    if (indexOfCreate > -1 && (indexOfInsert === -1 || indexOfCreate < indexOfInsert)) {
      this.state = STATES.CREATE;
      this.runReadSchema();
    } else if (indexOfInsert > -1 && (indexOfCreate === -1 || indexOfInsert < indexOfCreate)) {
      this.state = STATES.INSERT;
      this.runInsert();
    } else {
      this.state = null;
      this.next();
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
    const indexOfInsert = this.buffer.indexOf(INSERT_INTO_BUFF, this.bufferPosition);
    const indexOfValues = this.buffer.indexOf(VALUES_BUFF, indexOfInsert);

    if (indexOfValues === -1) {
      this.next();
    } else {
      const tablePos = indexOfInsert + INSERT_INTO_BUFF.length;
      const tableName = cleanVarName(this.buffer.slice(tablePos, indexOfValues).toString());
      this.setTable(tableName);

      this.bufferPosition = indexOfValues + VALUES_BUFF.length;
      this.continueInsert();
    }
  }

  continueInsert() {
    const writes = [];
    let row;
    let worker;
    let queueItem = this.getNextCommandParenSet();

    while (
      queueItem
      && queueItem !== COMMAND_EXEC_BUFF
      && this.readyWorkers.length
    ) {
      worker = this.readyWorkers.pop();
      row = `[${queueItem}]`;
      writes.push(this.writeToNextAvailableWorker(worker, row));

      queueItem = this.getNextCommandParenSet();
    }

    Promise
      .all(writes)
      .then(() => {
        if (!queueItem && this.bufferPosition >= this.buffer.length - 1) {
          return this.next();
        }

        if (queueItem === COMMAND_EXEC_BUFF) {
          this.cleanBuffer();
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
    const end = this.skipToEndOfCommand();

    this.cleanBuffer();
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
    const indexOfCreate = this.buffer.indexOf(CREATE_TABLE_BUFF);
    const indexOfNextParen = this.buffer.indexOf(BRACKET_OPEN_BUFF, indexOfCreate);
    const startPos = indexOfCreate + CREATE_TABLE_BUFF.length;

    if (indexOfNextParen === -1) {
      this.next();
    } else {
      // set buffer head to the end of values
      this.bufferPosition = startPos;

      const tableName = cleanVarName(this.buffer.slice(startPos + 1, indexOfNextParen).toString());
      const contents = this.getNextCommandParenSet();

      if (contents) {
        const createContents = contents.toString().trim();
        const columns = buildSchema(createContents);
        const schema = {
          name: tableName,
          columns,
        };

        this.tables[tableName] = schema;
        this.sendSchema(schema);

        // Done processing Create Table command. Jump to end of line or as far as possible
        this.runSeekEOL();
      } else {
        this.next();
      }
    }
  }


  // Buffer Control

  cleanBuffer() {
    this.buffer = this.buffer.slice(this.bufferPosition, this.buffer.length);
    this.bufferPosition = 0;
  }

  getNextCommandParenSet() {
    let shouldContinue = true;
    let sliced;

    while (
      shouldContinue === true
      && this.bufferPosition < this.buffer.length
    ) {
      if (this.isEscaped === false) {
        switch (this.buffer[this.bufferPosition]) {
          case ESCAPE_CHAR_OCTET:
            this.isEscaped = true;
            break;

          case STRING_OPENER_OCTET:
            this.isWithinString = !this.isWithinString;
            break;

          case BRACKET_OPEN_OCTET:
            if (!this.isWithinString) {
              if (this.openBracketCount === 0) {
                this.bracketStartPos = this.bufferPosition;
              }

              this.openBracketCount += 1;
            }
            break;

          case BRACKET_CLOSE_OCTET:
            if (!this.isWithinString) {
              this.openBracketCount -= 1;

              if (this.openBracketCount === 0) {
                this.bracketEndPos = this.bufferPosition;
                sliced = this.buffer.slice(this.bracketStartPos + 1, this.bracketEndPos);
                shouldContinue = false;
              }
            }
            break;

          case COMMAND_EXEC_OCTET:
            if (!this.isWithinString) {
              shouldContinue = false;
              sliced = COMMAND_EXEC_BUFF;
            }
            break;

          default:
            break;
        }
      } else {
        this.isEscaped = false;
      }

      this.bufferPosition += 1;
    }

    return sliced;
  }

  skipToEndOfCommand() {
    let shouldContinue = true;
    let sliced;

    while (
      shouldContinue === true
      && this.bufferPosition < this.buffer.length
    ) {
      if (this.isEscaped === false) {
        switch (this.buffer[this.bufferPosition]) {
          case ESCAPE_CHAR_OCTET:
            this.isEscaped = true;
            break;

          case STRING_OPENER_OCTET:
            this.isWithinString = !this.isWithinString;
            break;

          case COMMAND_EXEC_OCTET:
            if (!this.isWithinString) {
              shouldContinue = false;
              sliced = COMMAND_EXEC_BUFF;
            }
            break;

          default:
            break;
        }
      } else {
        this.isEscaped = false;
      }

      this.bufferPosition += 1;
    }

    return sliced;
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
    if (this.workerConfig) {
      this.workers
        .forEach((worker, i) => {
          const config = Object.assign({
            workerPart: i,
            totalWorkers: this.workers.length,
          }, this.workerConfig);
          sendToWorker(worker, { config });
        });
    }
  }

  sendSchema(schema) {
    this.workers
      .forEach((worker) => {
        sendToWorker(worker, { schema });
      });
  }
}


module.exports = MultiWriteable;
