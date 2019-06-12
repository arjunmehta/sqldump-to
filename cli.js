#!/usr/bin/env node

// Copyright (c) 2019 Arjun Mehta
// MIT License


const fs = require('fs');
const path = require('path');
const yargs = require('yargs');
const SQLConverterStream = require('./lib/sql-converter-stream');

const {
  'dir-output': dirOutput,
  input,
  workers,
  schema,
} = yargs
  .option('dir-output', { alias: 'd' })
  .option('input', { alias: 'i' })
  .option('workers', { alias: 'w' })
  .option('schema', { alias: 's' })
  .argv;


const converter = new SQLConverterStream({
  numWorkers: dirOutput ? parseInt(workers || 1, 10) : 1,
  outputDir: dirOutput,
  schemaFormat: schema,
});

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
