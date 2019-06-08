const yargs = require('yargs');
const MultiWriteable = require('./lib/multi-writable');

const { argv } = yargs
  .option('dir-output', { alias: 'd' })
  .option('workers', { alias: 'w' });


const writeStream = new MultiWriteable({
  numWorkers: argv.workers || 1,
  workerConfig: { outputDir: argv['dir-output'] },
});


process
  .stdin
  .pipe(writeStream)
  .on('finish', () => {
    process.exit();
  });
