#!/usr/bin/env node

// Copyright (c) 2019 Arjun Mehta
// MIT License


const yargs = require('yargs');
const MultiWriteable = require('./lib/multi-writable');

const { argv } = yargs
  .option('dir-output', { alias: 'd' })
  .option('workers', { alias: 'w' });


const writeStream = new MultiWriteable({
  numWorkers: argv['dir-output'] ? argv.workers || 1 : 1,
  workerConfig: { outputDir: argv['dir-output'] },
});


process
  .stdin
  .pipe(writeStream)
  .on('finish', () => {
    process.exit();
  });
