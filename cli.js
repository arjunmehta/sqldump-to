#!/usr/bin/env node

// Copyright (c) 2019 Arjun Mehta
// MIT License

const fs = require('fs');
const path = require('path');
const yargs = require('yargs');
const SQLConverterStream = require('./lib/sql-converter-stream');
const packageConfig = require('./package.json');


// Read in options

const {
  'dir-output': outputDir,
  input,
  workers,
  schema,
} = yargs
  .version(packageConfig.version)
  .alias('version', 'v')
  .help('help')
  .alias('help', 'h')
  .option('dir-output', {
    alias: 'd',
    description: 'Disable stdout and output to a directory',
    string: true,
  })
  .option('input', {
    alias: 'i',
    description: 'Disable stdin and read from a dumpfile instead',
    string: true,
  })
  .option('workers', {
    alias: 'w',
    description: 'Add extra workers and split their output',
    number: true,
  })
  .option('schema', {
    alias: 's',
    description: 'Output the detected schema as a JSON file',
    boolean: true,
  })
  .argv;


// Initialize main SQL Converter writable stream

const converter = new SQLConverterStream({
  outputDir,
  numWorkers: outputDir ? parseInt(workers || 1, 10) : 1,
  schemaFormat: schema,
});


// Pipe file or stdin

if (input) {
  const filePath = path.resolve(__dirname, input);

  fs.createReadStream(filePath)
    .pipe(converter)
    .on('finish', () => {
      process.exit();
    })
    .on('error', (err) => {
      throw err;
    });
} else {
  process
    .stdin
    .pipe(converter)
    .on('finish', () => {
      process.exit();
    });
}
