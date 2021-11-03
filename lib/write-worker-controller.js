const stream = require('stream');
const WriteWorker = require('./write-worker');

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

    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = new WriteWorker({
        config: { ...config, workerPart: i },
        parent: this,
      });

      this.workers[i] = worker;
      this.readyWorkers[i] = worker;
    }
  }

  _write(chunk, enc, next) {
    // const callnext = () => {
    //   console.log('Calling next');
    //   next();
    // };
    this.writeToNextAvailableWorker(chunk, next);
  }

  writeToNextAvailableWorker(rowBuffer, cb) {
    const worker = this.readyWorkers.pop();
    let callNext = cb;

    // worker.setCallNext(cb);

    if (this.readyWorkers.length) {
      callNext = () => {};
      cb();
    }

    // console.log({ rowBuffer });

    worker.postMessage(rowBuffer.toString(), callNext);
  }

  sendSchema(schema) {
    const schemaString = JSON.stringify({ schema });
    // const schemaBuffer = Buffer.from(`${schemaString}\n`);

    this
      .workers
      .forEach((worker) => {
        // worker.postMessage(schemaBuffer);
        worker.postMessage(schemaString);
        // worker.stdin.write(schemaBuffer);
      });
  }
}

module.exports = WriteWorkerController;
