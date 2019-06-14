const JSON5 = require('json5');
const { writeToFileDir, writeToStdout } = require('./util/fs');


class SQLSignalParserWriter {
  constructor() {
    this.databaseQueues = {
      default: {
        name: null,
        tableQueues: {},
      },
    };
    this.config = {};
    this.schema = {};
    this.isDone = false;

    this.writeQueue = this.writeQueue.bind(this);
    this.checkDone = this.checkDone.bind(this);

    this.checkQueueInterval = setInterval(this.writeQueue, 1000);
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

  get currentTableQueue() {
    const { databaseName, tableName } = this.schema;
    const database = databaseName || 'default';
    let databaseQueue = this.databaseQueues[database];

    if (!databaseQueue) {
      databaseQueue = { name: database, tableQueues: {} };
      this.databaseQueues[database] = databaseQueue;
    }

    if (!databaseQueue.tableQueues[tableName]) {
      databaseQueue.tableQueues[tableName] = [];
    }

    return databaseQueue.tableQueues[tableName];
  }

  handleData(data) {
    const msg = data
      .toString()
      .replace(/(?!\B'[^']*)(NULL|\\N)(?![^']*'\B)/g, 'null');

    try {
      const parsed = JSON5.parse(msg);

      if (Array.isArray(parsed)) {
        const record = {};

        parsed.forEach((val, i) => {
          const key = this.schema.columns[i].name;
          record[key] = val;
        });

        this.currentTableQueue.push(`${JSON.stringify(record)}\n`);
      } else if (parsed.schema) {
        Object.assign(this.schema, parsed.schema);
      } else if (parsed.config) {
        Object.assign(this.config, parsed.config);
      }
    } catch (err) {
      console.error('Unable to parse string', msg);
      console.error(err);
    }
  }

  end() {
    this.isDone = true;
    this.writeQueue();
  }

  checkDone() {
    if (this.isDone) {
      clearInterval(this.checkQueueInterval);
      process.exit();
    }
  }

  writeQueue() {
    const { databaseQueues, config } = this;
    const { outputDir } = config;
    const writes = [];

    Object.keys(databaseQueues).forEach((database) => {
      const databaseQueue = databaseQueues[database];

      Object.keys(databaseQueue.tableQueues).forEach((tableName) => {
        const databaseName = databaseQueue.name;
        const tableQueue = databaseQueue.tableQueues[tableName];
        const writeRows = tableQueue.splice(0, tableQueue.length);

        if (writeRows.length) {
          const directory = databaseName && outputDir ? `${outputDir}/${databaseName}` : outputDir;
          const writeString = writeRows.join('');

          if (directory) {
            const filename = `${tableName}${this.partSuffix}.json`;

            writes.push(writeToFileDir({
              directory,
              filename,
              content: writeString,
              append: true,
            }));
          } else {
            writes.push(writeToStdout(`${writeString}\n`));
          }
        }
      });
    });


    if (writes.length) {
      Promise.all(writes)
        .then(() => {
          this.checkDone();
        })
        .catch((err) => {
          throw err;
        });
    } else {
      this.checkDone();
    }
  }
}


module.exports = SQLSignalParserWriter;
