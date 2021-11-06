const stream = require('stream');
const path = require('path');
const { spawn } = require('child_process');

// Helper Functions

const workerPath = path.resolve(__dirname, 'write-worker-child');
const workerOptions = {
  detached: false,
  stdio: ['pipe', 'inherit', 'inherit'],
};

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
    this.queueLength = 100;
    this.currentQueue = 0;

    for (let i = 0; i < this.numWorkers; i += 1) {
      const worker = spawn('node', [workerPath], workerOptions)
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
