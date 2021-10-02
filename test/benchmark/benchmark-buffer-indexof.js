const fs = require('fs');
const path = require('path');
const Benchmark = require('benchmark');

const { smartIndexOf } = require('../../lib/sql-buffer');

const suite = new Benchmark.Suite();

const fileContent = fs.readFileSync(path.resolve(__dirname, '../fixtures', 'fixture.sql'));
const fileContentString = fileContent.toString();
const searchFor = Buffer.from('USE ');
const searchForString = searchFor.toString();

// add tests

console.log({
  'Native indexOf': fileContent.indexOf(searchFor),
  customIndexOfA: smartIndexOf(fileContent, searchFor),
});

suite
  .add('Native indexOf', () => {
    fileContent.indexOf(searchFor);
  })

  .add('Custom indexOf', () => {
    smartIndexOf(fileContent, searchFor);
  })

  .add('Converted String indexOf', () => {
    const str = fileContent.toString();
    str.indexOf(searchFor.toString());
  })

  .add('Native String indexOf', () => {
    fileContentString.indexOf(searchForString);
  })

  // add listeners
  .on('cycle', (event) => {
    console.log(String(event.target));
  })

  .on('complete', function completionMessage() {
    console.log(`Fastest is ${this.filter('fastest').map('name')}`);
  })

  // run async
  .run({ async: false });
