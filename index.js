const os = require('os');
const yargs = require('yargs');
const MultiWriteable = require('./lib/multi-writable');

const { argv } = yargs
  .option('dir', { alias: 'd' })
  .option('workers', { alias: 'w' });


const writeStream = new MultiWriteable({
  numWorkers: argv.workers || Math.round(os.cpus().length / 2) - 1 || 1,
  workerConfig: { outputDir: argv.dir },
});


process
  .stdin
  .pipe(writeStream)
  .on('finish', () => {
    process.exit();
  });
