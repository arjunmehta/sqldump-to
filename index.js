const yargs = require('yargs');
const MultiWriteable = require('./lib/multi-writable');

const { argv } = yargs
  .option('dir', { alias: 'd' })
  .option('workers', { alias: 'w' });

const writeStream = new MultiWriteable({
  numWorkers: argv.workers,
  workerConfig: { outputDir: argv.dir },
});

process
  .stdin
  .pipe(writeStream)
  .on('finish', () => {
    process.exit();
  });
