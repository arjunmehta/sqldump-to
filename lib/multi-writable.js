// NOTTT WORKING
const { spawn } = require('child_process');
const stream = require('stream');


const BUFFER_VALUES = {
  CREATE_TABLE: Buffer.from('CREATE TABLE '),
  INSERT_INTO: Buffer.from('INSERT INTO '),
  VALUES: Buffer.from(' VALUES '),
  COMMAND_EXEC: Buffer.from(';'),
  BRACKET_OPEN: Buffer.from('('),
  BRACKET_CLOSE: Buffer.from(')'),
  STRING_OPENER: Buffer.from('\''),
  ESCAPE_CHAR: Buffer.from('\\'),
};

const OCTETS = {
  COMMAND_EXEC_OCTET: BUFFER_VALUES.COMMAND_EXEC[0],
  STRING_OPENER_OCTET: BUFFER_VALUES.STRING_OPENER[0],
  ESCAPE_CHAR_OCTET: BUFFER_VALUES.ESCAPE_CHAR[0],
  BRACKET_OPEN_OCTET: BUFFER_VALUES.BRACKET_OPEN[0],
  BRACKET_CLOSE_OCTET: BUFFER_VALUES.BRACKET_CLOSE[0],
};

const STATES = {
  INSERT: 'INSERT',
  CREATE: 'CREATE',
};


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


function cleanVarName(str) {
  return str
    .replace(/['"`]+/g, '')
    .trim();
}


function sendToWorker(worker, obj, cb = () => {}) {
  const str = typeof obj === 'string' ? obj : JSON.stringify(obj);
  const configBuffer = Buffer.from(`${str}\n`);

  worker.stdin.write(configBuffer, cb);
}


class MultiWriteable extends stream.Writable {
  constructor(config = {}) {
    super();

    const {
      numWorkers,
      workerConfig,
    } = Object.assign({}, config);

    this.tables = { };
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
      const worker = spawn(
        'node',
        [`${__dirname}/worker`], {
          detached: true,
          stdio: ['pipe', 'inherit', 'inherit'],
        },
      );

      worker
        .on('error', (err) => {
          throw err;
        })
        .on('exit', (exitCode) => {
          console.log(`Worker ${i}-PID ${worker.pid} exited with code: ${exitCode}`);
        });

      // worker
      //   .stdout
      //   .pipe(split())
      //   .on('data', (data) => {
      //     console.log(data.toString());
      //   });

      this.workers[i] = worker;
      this.readyWorkers[i] = worker;
    }

    this.sendConfig();
  }

  _write(chunk, enc, next) {
    this.next = next;
    this.buffer = Buffer.concat([this.buffer, chunk]);
    this.handleNewBuffer();
    // this.flushQueueToAvailableWorkers(next);
  }


  handleNewBuffer() {
    switch (this.state) {
      case STATES.INSERT:
        this.continueInsert();
        break;
      case STATES.CREATE:
        this.runReadSchema();
        break;
      default:
        this.determineState();
        break;
    }
  }

  cleanBuffer() {
    this.buffer = this.buffer.slice(this.bufferPosition, this.buffer.length);
    this.bufferPosition = 0;
  }

  determineState() {
    const indexOfCreate = this.buffer.indexOf(BUFFER_VALUES.CREATE_TABLE, this.bufferPosition);
    const indexOfInsert = this.buffer.indexOf(BUFFER_VALUES.INSERT_INTO, this.bufferPosition);
    // console.log('DETERMINING STATE at', this.bufferPosition);

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

  runInsert() {
    // console.log('Running Insert');
    const { INSERT_INTO, VALUES } = BUFFER_VALUES;

    const indexOfInsert = this.buffer.indexOf(INSERT_INTO, this.bufferPosition);
    const indexOfValues = this.buffer.indexOf(VALUES, indexOfInsert);

    if (indexOfValues === -1) {
      this.next();
    } else {
      const tablePos = indexOfInsert + INSERT_INTO.length;
      // set buffer head to the end of values
      this.bufferPosition = indexOfValues + VALUES.length;
      const tableName = cleanVarName(this.buffer.slice(tablePos, indexOfValues).toString());
      this.setTable(tableName);
      this.continueInsert();
    }
  }

  continueInsert() {
    const { COMMAND_EXEC } = BUFFER_VALUES;

    let parens = this.getNextCommandParenSet();
    while (parens && parens !== COMMAND_EXEC) {
      // console.log({ value: parens.toString(), pos: this.bufferPosition });
      parens = this.getNextCommandParenSet();
    }

    if (!parens && this.bufferPosition >= this.buffer.length - 1) {
      this.next();
    }

    if (parens === COMMAND_EXEC) {
      this.cleanBuffer();
      this.determineState();
    }
  }

  setTable(tableName) {
    if (this.tables[tableName]) {
      this.currentTable = tableName;
    } else {
      throw new Error(`The schema for table '${tableName}' has not been set yet. Your dump needs a CREATE TABLE query.`);
    }
  }

  runReadSchema() {
    // console.log('Running Create Table');
    const {
      CREATE_TABLE,
      BRACKET_OPEN,
    } = BUFFER_VALUES;

    const indexOfCreate = this.buffer.indexOf(CREATE_TABLE);
    const indexOfNextParen = this.buffer.indexOf(BRACKET_OPEN, indexOfCreate);
    const startPos = indexOfCreate + CREATE_TABLE.length;

    // set buffer head to the end of values
    this.bufferPosition = startPos;

    const tableName = cleanVarName(
      this.buffer.slice(startPos + 1, indexOfNextParen).toString(),
    );

    const contents = this.getNextCommandParenSet();

    if (contents) {
      const createContents = contents.toString().trim();
      const schema = buildSchema(createContents);

      this.tables[tableName] = {
        name: tableName,
        schema,
      };

      this.sendSchema(schema);
    }

    console.log(this.tables);

    this.skipToEndOfCommand();
    this.cleanBuffer();
    this.determineState();
  }

  getNextCommandParenSet() {
    let shouldContinue = true;
    let sliced;

    while (shouldContinue === true && this.bufferPosition < this.buffer.length - 1) {
      if (this.isEscaped === false) {
        switch (this.buffer[this.bufferPosition]) {
          case OCTETS.ESCAPE_CHAR_OCTET:
            this.isEscaped = true;
            break;

          case OCTETS.STRING_OPENER_OCTET:
            this.isWithinString = !this.isWithinString;
            break;

          case OCTETS.BRACKET_OPEN_OCTET:
            if (!this.isWithinString) {
              if (this.openBracketCount === 0) {
                this.bracketStartPos = this.bufferPosition;
              }

              this.openBracketCount += 1;
            }
            break;

          case OCTETS.BRACKET_CLOSE_OCTET:
            if (!this.isWithinString) {
              this.openBracketCount -= 1;

              if (this.openBracketCount === 0) {
                this.bracketEndPos = this.bufferPosition;
                sliced = this.buffer.slice(this.bracketStartPos + 1, this.bracketEndPos);
                shouldContinue = false;
              }
            }
            break;

          case OCTETS.COMMAND_EXEC_OCTET:
            if (!this.isWithinString) {
              shouldContinue = false;
              sliced = BUFFER_VALUES.COMMAND_EXEC;
            }
            break;

          default:
            break;
        }
      } else {
        this.isEscaped = false;
      }

      this.bufferPosition += 1;
      // shouldContinue = safeContinue && shouldContinue;
    }

    return sliced;
  }

  skipToEndOfCommand() {
    let shouldContinue = true;
    let safeContinue = false;

    while (shouldContinue === true) {
      if (this.isEscaped === false) {
        switch (this.buffer[this.bufferPosition]) {
          case OCTETS.ESCAPE_CHAR_OCTET:
            this.isEscaped = true;
            break;

          case OCTETS.STRING_OPENER_OCTET:
            this.isWithinString = !this.isWithinString;
            break;

          case OCTETS.COMMAND_EXEC_OCTET:
            if (!this.isWithinString) {
              shouldContinue = false;
            }
            break;

          default:
            break;
        }
      } else {
        this.isEscaped = false;
      }

      safeContinue = this.incrementBuffer();
      shouldContinue = safeContinue && shouldContinue;
    }

    if (!safeContinue) this.next();
  }

  incrementBuffer() {
    this.bufferPosition += 1;

    if (this.bufferPosition > this.buffer.length - 1) {
      console.log({
        pos: this.bufferPosition,
        length: this.buffer.length,
        isWithinString: this.isWithinString,
        isEscaped: this.isEscaped,
      });
      return false;
    }

    return true;
  }


  flushQueueToAvailableWorkers() {
    const nextWorkers = this.readyWorkers.splice(0, this.queue.length);
    const writes = [];
    let queueItem;
    let row;

    for (let i = 0; i < nextWorkers.length; i += 1) {
      queueItem = this.queue.shift();
      row = this.processQueueItem(queueItem);
      writes.push(this.writeToNextAvailableWorker(nextWorkers[i], row));
    }

    Promise
      .all(writes)
      .then(() => {
        if (this.queue.length) {
          return this.flushQueueToAvailableWorkers();
        }

        return this.next();
      })
      .catch((err) => {
        console.error(err);
      });
  }

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
          const config = Object.assign({ workerPart: i }, this.workerConfig);
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