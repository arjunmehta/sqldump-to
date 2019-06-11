#!/usr/bin/env node

// Copyright (c) 2019 Arjun Mehta
// MIT License


const yargs = require('yargs');
const WriteableController = require('./lib/writable-controller');

const { argv } = yargs
  .option('dir-output', { alias: 'd' })
  .option('workers', { alias: 'w' })
  .option('schema', { alias: 's' });


const writeStream = new WriteableController({
  numWorkers: argv['dir-output'] ? parseInt(argv.workers || 1, 10) : 1,
  outputDir: argv['dir-output'],
  schemaFormat: argv.schema,
});


process
  .stdin
  .pipe(writeStream)
  .on('finish', () => {
    process.exit();
  });
