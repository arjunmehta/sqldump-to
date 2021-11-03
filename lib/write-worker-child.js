const { workerData, parentPort } = require('worker_threads');

// const split = require('split2');
const SQLSignalParserWriter = require('./sql-signal-parser-writer');

const writer = new SQLSignalParserWriter({ config: workerData });

parentPort.on('message', (value) => {
  writer.handleData(value, (msg) => {
    if (msg === 'done') {
      parentPort.postMessage('done');
    }
  });
});
