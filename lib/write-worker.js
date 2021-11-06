const { Worker } = require('worker_threads');

class WriteWorker {
  constructor({ config, parent }) {
    this.worker = new Worker(`${__dirname}/write-worker-child.js`, { workerData: config });
    this.parent = parent;
    this.callNext = () => {};

    this.worker.on('message', (msg) => {
      if (msg === 1) {
        this.parent.readyWorkers.push(this);
        this.callNext();
      }
    });
  }

  setCallNext(cb) {
    this.callNext = cb;
  }

  postMessageAsBuffer(msg, cb) {
    const buf = new Uint8Array(msg).buffer;

    if (cb) {
      this.callNext = cb;
    }

    this.worker.postMessage(buf, [buf]);
  }
}

module.exports = WriteWorker;
