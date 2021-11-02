const { Worker, workerPath } = require('worker_threads');

class WriteWorker {
  constructor({ config, parent }) {
    this.worker = new Worker(workerPath, { workerData: config });
    this.parent = parent;
    this.callNext = () => {};

    this.worker.on('message', (msg) => {
      if (msg === 'done') {
        this.callNext();
        this.parent.readyWorkers.push(this);
      }
    });
  }

  setCallNext(cb) {
    this.callNext = cb;
  }

  postMessage(msg, arr) {
    this.worker.postMessage(msg, arr);
  }
}

module.exports = WriteWorker;
