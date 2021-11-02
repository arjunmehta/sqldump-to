const WriteWorker = require('./write-worker');

// Primary Class Definition

class WriteWorkerController {
  constructor(config = {
    numWorkers: 1,
    outputDir: null,
    schemaFormat: null,
  }) {
    Object.assign(this, config);

    this.workers = [];
    this.readyWorkers = [];

    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = new WriteWorker({ config, parent: this });

      this.workers[i] = worker;
      this.readyWorkers[i] = worker;
    }
  }

  writeToNextAvailableWorker(rowBuffer, cb) {
    const worker = this.readyWorkers.pop();

    worker.setCallNext(cb);

    if (this.readyWorkers.length) {
      worker.setCallNext(() => {});
      cb();
    }

    worker.postMessage(rowBuffer, [rowBuffer]);
  }

  sendConfig() {
    const workerConfig = {
      outputDir: this.outputDir,
      totalWorkers: this.workers.length,
    };

    this.workers
      .forEach((worker, i) => {
        const config = { workerPart: i, ...workerConfig };
        const configString = JSON.stringify({ config });
        const configBuffer = Buffer.from(`${configString}\n`);

        worker.stdin.write(configBuffer);
      });
  }

  sendSchema(schema) {
    const schemaString = JSON.stringify({ schema });
    const schemaBuffer = Buffer.from(`${schemaString}\n`);

    this.workers
      .forEach((worker) => {
        worker.stdin.write(schemaBuffer);
      });
  }
}

module.exports = WriteWorkerController;
