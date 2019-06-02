const MultiWriteable = require('./multi-writable');

const writeStream = new MultiWriteable({
  workerConfig: {
    outputDir: './output',
  },
});

process
  .stdin
  .pipe(writeStream)
  .on('close', () => {
    process.exit();
  });
