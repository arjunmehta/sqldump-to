const { workerData, parentPort } = require('worker_threads');

// const split = require('split2');
const SQLSignalParserWriter = require('./sql-signal-parser-writer');

const writer = new SQLSignalParserWriter({ config: workerData });

parentPort.on('message', (value) => {
  writer.handleData(value, (msg) => {
    // console.log('Worker message', msg);
    if (msg === 'done') {
      parentPort.postMessage('done');
    }
  });
});

// process
//   .stdin
//   .pipe(split())
//   .on('data', (data) => {
//     writer.handleData(data);
//   })
//   .on('end', () => {
//     writer.end();
//   });
