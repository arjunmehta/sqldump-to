const JSON5 = require('json5');
const { createWriteFileStream } = require('./util/fs');


class SQLSignalParserWriter {
  constructor() {
    this.isDone = false;
    this.config = {};
    this.schema = {};
    this.databaseWriteQueues = { default: {} };

    this.isWritingToFile = false;
    this.currentTableQueue = null;
    this.writeFromBuffers = this.writeFromBuffers.bind(this);
    this.checkDone = this.checkDone.bind(this);

    this.checkQueueInterval = setInterval(this.writeFromBuffers, 10);
  }

  get partSuffix() {
    const {
      workerPart,
      totalWorkers,
    } = this.config;

    let partSuffix = `_${process.pid}`;

    if (totalWorkers <= 1) {
      partSuffix = '';
    } else if (typeof workerPart === 'number') {
      partSuffix = `_${workerPart}`;
    }

    return partSuffix;
  }

  setCurrentTableQueue() {
    const { databaseName, tableName } = this.schema;
    const database = databaseName || 'default';
    let databaseQueue = this.databaseWriteQueues[database];

    if (databaseQueue === undefined) {
      databaseQueue = { name: database, tableBuffers: {} };
      this.databaseWriteQueues[database] = databaseQueue;
    }

    if (databaseQueue[tableName] === undefined) {
      let stream = process.stdout;

      if (this.isWritingToFile === true) {
        const { outputDir } = this.config;
        const directory = databaseName ? `${outputDir}/${databaseName}` : outputDir;
        const filename = `${tableName}${this.partSuffix}.json`;

        stream = createWriteFileStream({ directory, filename });
      }

      databaseQueue[tableName] = {
        buffer: '',
        stream,
      };
    }

    this.currentTableQueue = databaseQueue[tableName];
  }

  handleData(data) {
    const msg = data
      .toString()
      .replace(/(?!\B'[^']*)(NULL|\\N)(?![^']*'\B)/g, 'null');

    try {
      const parsed = JSON5.parse(msg);

      if (Array.isArray(parsed)) {
        const record = {};

        for (let i = 0; i < parsed.length; i += 1) {
          const key = this.schema.columns[i].name;
          record[key] = parsed[i];
        }

        this.currentTableQueue.buffer += `${JSON.stringify(record)}\n`;
      } else if (parsed.schema) {
        Object.assign(this.schema, parsed.schema);
        this.setCurrentTableQueue();
      } else if (parsed.config) {
        Object.assign(this.config, parsed.config);

        if (parsed.config.outputDir) {
          this.isWritingToFile = true;
        }
      }
    } catch (err) {
      console.error('Unable to parse string', msg);
      console.error(err);
    }
  }

  end() {
    this.isDone = true;
    this.writeFromBuffers();
  }

  checkDone() {
    if (this.isDone === true) {
      clearInterval(this.checkQueueInterval);
      process.exit();
    }
  }

  writeFromBuffers() {
    const { databaseWriteQueues } = this;
    const writes = [];

    Object.keys(databaseWriteQueues).forEach((database) => {
      const databaseQueue = databaseWriteQueues[database];

      Object.keys(databaseQueue).forEach((tableName) => {
        const { buffer, stream } = databaseQueue[tableName];
        databaseQueue[tableName].buffer = '';

        if (buffer.length) {
          writes.push(new Promise((resolve) => {
            stream.write(buffer, resolve);
          }));
        }
      });
    });

    if (writes.length) {
      Promise.all(writes)
        .then(() => { this.checkDone(); })
        .catch((err) => { throw err; });
    } else {
      this.checkDone();
    }
  }
}


module.exports = SQLSignalParserWriter;
