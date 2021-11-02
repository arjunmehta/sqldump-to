const path = require('path');
const { spawn } = require('child_process');
const { Worker, isMainThread, parentPort } = require('worker_threads');

// Helper Functions

const workerPath = path.resolve(__dirname, 'write-worker-child');
const workerOptions = {
  detached: false,
  stdio: ['pipe', 'inherit', 'inherit'],
};

// Primary Class Definition

class WriteWorker {
  constructor({ config, parent }) {
    this.worker = new Worker(workerPath, { workerData: config });
    this.callNext = () => {};

    worker.on('message', (msg) => {
      if (msg === 'done') {
        this.callNext();
      }
    });
  }

  setCallNext(cb) {
    this.callNext = cb;
  }
}

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
      const worker = new WriteWorker({config, parent: this});

      // const worker = spawn('node', [workerPath], workerOptions)
      //   .on('error', (err) => {
      //     throw err;
      //   })
      //   .on('exit', (exitCode) => {
      //     if (exitCode !== 0) {
      //       console.error(`Worker ${i}-PID ${worker.pid} exited with code: ${exitCode}`);
      //     }
      //   });

      this.workers[i] = worker
      this.readyWorkers[i] = worker;
    }
  }

  writeToNextAvailableWorker(rowBuffer, cb) {
    const worker = this.readyWorkers.pop();

    worker.setCallNext(cb);

    if (this.readyWorkers.length) {
      worker.setCallNext(() => {}));
      cb();
    }

    // worker.stdin.write(rowBuffer, () => {
    //   this.readyWorkers.push(worker);
    //   callNext();
    // });

    worker.postMessage(rowBuffer, [rowBuffer])

    () => {
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
