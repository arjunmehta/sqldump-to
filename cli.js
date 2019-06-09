#!/usr/bin/env node

// Copyright (c) 2019 Arjun Mehta
// MIT License


const yargs = require('yargs');
const MultiWriteable = require('./lib/multi-writable');

const { argv } = yargs
  .option('dir-output', { alias: 'd' })
  .option('workers', { alias: 'w' })
  .option('schema', { alias: 's' });


const writeStream = new MultiWriteable({
  numWorkers: argv['dir-output'] ? argv.workers || 1 : 1,
  outputDir: argv['dir-output'],
  schemaFormat: argv.schema,
});


process
  .stdin
  .pipe(writeStream)
  .on('finish', () => {
    process.exit();
  });
