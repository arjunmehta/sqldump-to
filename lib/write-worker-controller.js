const stream = require('stream');
// const WriteWorker = require('./write-worker');
const { Worker } = require('worker_threads');

// Primary Class Definition

class WriteWorkerController extends stream.Writable {
  constructor(config = {
    numWorkers: 1,
    outputDir: null,
    schemaFormat: null,
  }) {
    super();
    Object.assign(this, config);

    this.workers = [];
    this.readyWorkers = [];
    this.buffer = Buffer.from('');
    this.queueLength = 55;
    this.currentQueue = 0;

    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = new Worker(`${__dirname}/write-worker-child.js`, {
        stdin: true,
        workerData: { ...config, workerPart: i },
      });

      // const worker = new WriteWorker({
      //   config: { ...config, workerPart: i },
      //   parent: this,
      // });

      this.workers[i] = worker;
      this.readyWorkers[i] = worker;
    }
  }

  _write(chunk, enc, next) {
    this.currentQueue += 1;
    if (this.currentQueue >= this.queueLength) {
      this.writeToNextAvailableWorker(this.buffer, next);
      this.buffer = Buffer.from('');
      this.currentQueue = 0;
    } else {
      this.buffer = Buffer.concat([this.buffer, chunk]);
      next();
    }
  }

  writeToNextAvailableWorker(rowBuffer, cb) {
    // console.log('Writing to next available');
    const worker = this.readyWorkers.pop();
    let callNext = cb;

    if (this.readyWorkers.length) {
      callNext = () => {};
      cb();
    }

    worker.stdin.write(rowBuffer, () => {
      this.readyWorkers.push(worker);
      callNext();
    });
  }

  sendSchema(schema) {
    const schemaString = JSON.stringify({ schema });
    const schemaBuffer = Buffer.from(`${schemaString}\n`);

    this
      .workers
      .forEach((worker) => {
        worker.stdin.write(schemaBuffer);
      });
  }
}

module.exports = WriteWorkerController;
