const os = require('os');
const { spawn } = require('child_process');
const stream = require('stream');


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
    } = Object.assign({
      numWorkers: Math.round(os.cpus().length / 2) - 1 || 1,
    }, config);

    this.workerConfig = workerConfig;
    this.numWorkers = numWorkers;
    this.buffer = '';
    this.delimeter = '),(';
    this.queue = [];
    this.workers = [];
    this.readyWorkers = [];

    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = spawn(
        'node',
        [`${__dirname}/worker`],
        { detached: true, stdio: ['pipe', 'inherit', 'inherit'] },
      );

      worker
        .on('error', (err) => {
          throw err;
        })
        .on('exit', (exitCode) => {
          console.log(`Worker ${i}-PID ${worker.pid} exited with code: ${exitCode}`);
        });

      this.workers[i] = worker;
      this.readyWorkers[i] = worker;
    }

    this.sendConfig();
  }

  _write(chunk, enc, next) {
    const str = chunk.toString();
    this.buffer += str;

    const queue = this.buffer.split(this.delimeter);
    const last = queue.pop();

    this.buffer = last;
    this.queue = this.queue.concat(queue);
    this.flushQueueToAvailableWorkers(next);
  }

  flushQueueToAvailableWorkers(next) {
    const nextWorkers = this.readyWorkers.splice(0, this.queue.length);

    const writes = nextWorkers
      .map((worker) => {
        const queueItem = this.queue.shift();
        const row = this.processQueueItem(queueItem);
        return this.writeToNextAvailableWorker(worker, row);
      });

    Promise
      .all(writes)
      .then(() => {
        if (this.queue.length) {
          return this.flushQueueToAvailableWorkers(next);
        }

        return next();
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

  buildSchema(matches) {
    const commands = matches[1].split('\n');
    const schema = {
      name: null,
      columns: [],
    };

    commands
      .forEach((command, i) => {
        const cleanCommand = command.slice(0, -1).trim();
        const [firstChar] = cleanCommand;

        if (
          firstChar === '`'
              || firstChar === '\''
              || firstChar === '"'
        ) {
          const comm = cleanCommand.split(' ');
          const [, name] = comm[0].match(/`([^]*?)`/);

          if (i === 0) {
            // name of table
            schema.name = name;
          } else {
            // column names
            const type = comm[1];
            const column = { name, type };

            schema.columns.push(column);
          }
        }
      });

    this.sendSchema(schema);
  }

  processQueueItem(queueItem) {
    let row = queueItem;
    const hasBeg = row.split('` VALUES (');
    const hasEnd = row.split(');\n');

    if (hasEnd.length > 1) {
      [row] = hasEnd;
    } else if (hasBeg.length > 1) {
      let beginning;
      [beginning, row] = hasBeg;

      const matches = beginning.match(/CREATE TABLE([^]*?);/);

      if (matches && matches.length > 1) {
        this.buildSchema(matches);
      }
    }

    return `[${row}]`;
  }
}


module.exports = MultiWriteable;
