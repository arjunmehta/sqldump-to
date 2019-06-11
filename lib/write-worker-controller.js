const { spawn } = require('child_process');


// Helper Functions


function sendToWorker(worker, obj, cb = () => {}) {
  const str = typeof obj === 'string' ? obj : JSON.stringify(obj);
  const configBuffer = Buffer.from(`${str}\n`);

  worker.stdin.write(configBuffer, cb);
}


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
      const worker = spawn('node',
        [`${__dirname}/write-worker`], {
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


module.exports = WriteWorkerController;
