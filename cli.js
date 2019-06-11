#!/usr/bin/env node

// Copyright (c) 2019 Arjun Mehta
// MIT License


const yargs = require('yargs');
const SQLConverterStream = require('./lib/sql-converter-stream');

const { argv } = yargs
  .option('dir-output', { alias: 'd' })
  .option('workers', { alias: 'w' })
  .option('schema', { alias: 's' });


const converter = new SQLConverterStream({
  numWorkers: argv['dir-output'] ? parseInt(argv.workers || 1, 10) : 1,
  outputDir: argv['dir-output'],
  schemaFormat: argv.schema,
});


process
  .stdin
  .pipe(converter)
  .on('finish', () => {
    process.exit();
  });
