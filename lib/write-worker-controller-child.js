const yargs = require('yargs');
const split = require('split2');
const WriteWorkerController = require('./sql-signal-parser-writer');

const {
  'dir-output': outputDir,
  workers: numWorkers,
} = yargs
  .option('dir-output', {
    alias: 'd',
    description: 'Disable stdout and output to a directory',
    string: true,
  })
  .option('workers', {
    alias: 'w',
    description: 'Add extra workers and split their output',
    number: true,
  })
  .argv;

const writer = new WriteWorkerController({ outputDir, numWorkers });

process
  .stdin
  .pipe(split())
  .on('data', (data) => {
    writer.handleData(data);
  })
  .on('end', () => {
    writer.end();
  });
