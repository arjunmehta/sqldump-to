const { workerData, parentPort } = require('worker_threads');
const split = require('split2');
const SQLSignalParserWriter = require('./sql-signal-parser-writer');

const writer = new SQLSignalParserWriter({ config: workerData });

parentPort.on('message', (message) => {
  try {
    const { schema } = message;

    if (schema) {
      writer.handleSchema({ schema });
    }
  } catch (error) {
    console.error('Error parsing message on write worker child', { message, error });
  }
});

process
  .stdin
  .pipe(split())
  .on('data', (data) => {
    writer.handleData(data);
  })
  .on('end', () => {
    writer.end();
  });
