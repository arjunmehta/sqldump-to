const split = require('split2');
const SQLSignalParserWriter = require('./sql-signal-parser-writer');

const writer = new SQLSignalParserWriter();


process
  .stdin
  .pipe(split())
  .on('data', (data) => {
    writer.handleData(data);
  })
  .on('end', () => {
    writer.end();
  });
