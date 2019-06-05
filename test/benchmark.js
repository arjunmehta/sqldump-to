const fs = require('fs');
const path = require('path');
const Benchmark = require('benchmark');

const suite = new Benchmark.Suite();

const fileContent = fs.readFileSync(path.resolve(__dirname, 'fixture.sql'));
const bufDelimeter = Buffer.from('),(');
const bufDelimeterLength = bufDelimeter.length;
const createTable = Buffer.from('CREATE TABLE ');
const insertInto = Buffer.from('INSERT INTO ');
const values = Buffer.from(' VALUES ');
const bracketOpen = Buffer.from('(');
const bracketClose = Buffer.from(')');

const stringOpener = Buffer.from('\'');
const escapeChar = Buffer.from('\\');

const stringOpenerOctet = stringOpener[0];
const escapeCharOctet = escapeChar[0];
const bracketOpenOctet = bracketOpen[0];
const bracketCloseOctet = bracketClose[0];


// add tests
suite
  .add('String Split', () => {
    const fileString = fileContent.toString();
    return fileString.split('),(');
  })

  .add('indexOf, slice via delimeter', () => {
    let start = 0;
    let idx = fileContent.indexOf(bufDelimeter);
    let sliced;

    while (idx !== -1) {
      sliced = fileContent.slice(start, idx);
      start = idx + bufDelimeterLength;
      idx = fileContent.indexOf(bufDelimeter, start);
    }
  })

  .add('indexOf, slice, toString via delimeter', () => {
    let start = 0;
    let idx = fileContent.indexOf(bufDelimeter);
    let sliced;

    while (idx !== -1) {
      sliced = fileContent.toString(undefined, start, idx);
      start = idx + bufDelimeterLength;
      idx = fileContent.indexOf(bufDelimeter, start);
    }
  })

  .add('count brackets indexOf, slice delimeter', () => {
    let openBracketCount = 0;
    let startPos = 0;
    let endPos = 0;
    let isWithinString = false;
    let isEscaped = false;
    let sliced;

    for (let i = 0; i < fileContent.length; i += 1) {
      if (isEscaped === false) {
        switch (fileContent[i]) {
          case escapeCharOctet:
            isEscaped = true;
            break;

          case stringOpenerOctet:
            isWithinString = !isWithinString;
            break;

          case bracketOpenOctet:
            if (!isWithinString) {
              if (openBracketCount === 0) {
                startPos = i;
              }

              openBracketCount += 1;
            }
            break;

          case bracketCloseOctet:
            if (!isWithinString) {
              openBracketCount -= 1;

              if (openBracketCount === 0) {
                endPos = i;
                sliced = fileContent.slice(startPos + 1, endPos);
                // console.log({ sliced: sliced.toString(), startPos, endPos });
              }
            }
            break;

          default:
            break;
        }
      } else {
        isEscaped = false;
      }
    }
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
