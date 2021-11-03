const { Worker } = require('worker_threads');

class WriteWorker {
  constructor({ config, parent }) {
    this.worker = new Worker(`${__dirname}/write-worker-child.js`, { workerData: config });
    this.parent = parent;
    this.callNext = () => {};

    this.worker.on('message', (msg) => {
      // console.log('recieved message from worker', msg);

      if (msg === 'done') {
        this.parent.readyWorkers.push(this);
        this.callNext();
      }
    });
  }

  setCallNext(cb) {
    this.callNext = cb;
  }

  postMessage(msg, cb) {
    if (cb) {
      this.callNext = cb;
    }

    // console.log('Sending', { msg });

    this.worker.postMessage(msg);
  }
}

module.exports = WriteWorker;
