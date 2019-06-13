const JSON5 = require('json5');
const { writeToFileDir } = require('./util/fs');


class SQLSignalParserWriter {
  constructor() {
    this.queue = [];
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

  handleData(data) {
    const msg = data
      .toString()
      .replace(/(?!\B'[^']*)(NULL|\\N)(?![^']*'\B)/g, 'null');

    try {
      const parsed = JSON5.parse(msg);

      if (parsed.schema) {
        Object.assign(this.schema, parsed.schema);
      } else if (parsed.config) {
        Object.assign(this.config, parsed.config);
      } else if (Array.isArray(parsed)) {
        const record = {};

        parsed.forEach((val, i) => {
          const key = this.schema.columns[i].name;
          record[key] = val;
        });

        this.queue.push(`${JSON.stringify(record)}\n`);
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
    const writeRows = this.queue.splice(0, this.queue.length);

    if (writeRows.length) {
      const writeString = writeRows.join('');
      const { outputDir: directory } = this.config;

      if (directory) {
        const filename = `${this.schema.name}${this.partSuffix}.json`;

        writeToFileDir({
          directory,
          filename,
          content: writeString,
          append: true,
        }, this.checkDone);
      } else {
        process.stdout.write(`${writeString}\n`, this.checkDone);
      }
    } else {
      this.checkDone();
    }
  }
}


module.exports = SQLSignalParserWriter;
