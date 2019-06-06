const fs = require('fs');
const path = require('path');
const MultiWriteable = require('../lib/multi-writable');

const fileContent = fs.readFileSync(path.resolve(__dirname, 'fixture.sql'));
const writable = new MultiWriteable();
writable.buffer = fileContent;

writable.runReadSchema();

console.log('Total Buffer length', fileContent.length);
