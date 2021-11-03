const { Worker } = require('worker_threads');

class WriteWorker {
  constructor({ config, parent }) {
    this.worker = new Worker(`${__dirname}/write-worker-child.js`, { workerData: config });
    this.parent = parent;
    this.callNext = () => {};

    this.worker.on('message', (msg) => {
      if (msg === 'done') {
        this.parent.readyWorkers.push(this);
        this.callNext();
      }
    });
  }

  setCallNext(cb) {
    this.callNext = cb;
  }

  postMessageAsBuffer(msg, cb) {
    if (cb) {
      this.callNext = cb;
    }

    this.worker.postMessage(msg, [new Uint8Array(msg).buffer]);
  }
}

module.exports = WriteWorker;
