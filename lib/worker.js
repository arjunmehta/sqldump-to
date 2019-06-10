const JSON5 = require('json5');
const split = require('split2');
const { writeToFileDir } = require('./util/fs');


const queue = [];
const config = {};
const schema = {};
let done = false;

const inter = setInterval(writeQueue, 1000);


function getPartSuffix() {
  const {
    workerPart,
    totalWorkers,
  } = config;

  let partSuffix = `_${process.pid}`;

  if (totalWorkers <= 1) {
    partSuffix = '';
  } else if (typeof workerPart === 'number') {
    partSuffix = `_${workerPart}`;
  }

  return partSuffix;
}

function checkDone() {
  if (done) {
    clearInterval(inter);
    process.exit();
  }
}

function writeQueue() {
  const writeRows = queue.splice(0, queue.length);

  if (writeRows.length) {
    const writeString = writeRows.join('');
    const { outputDir: directory } = config;

    if (directory) {
      const partSuffix = getPartSuffix();
      const filename = `${schema.name}${partSuffix}.json`;

      writeToFileDir({
        directory,
        filename,
        content: writeString,
        append: true,
      }, checkDone);
    } else {
      process.stdout.write(`${writeString}\n`, checkDone);
    }
  } else {
    checkDone();
  }
}

process
  .stdin
  .pipe(split())
  .on('data', (data) => {
    const msg = data
      .toString()
      .replace(/((?!'[\w\s]*)NULL(?![\w\s]*'))/g, 'null');

    try {
      const parsed = JSON5.parse(msg);

      if (parsed.schema) {
        Object.assign(schema, parsed.schema);
      } else if (parsed.config) {
        Object.assign(config, parsed.config);
      } else if (Array.isArray(parsed)) {
        const record = {};

        parsed.forEach((val, i) => {
          const key = schema.columns[i].name;
          record[key] = val;
        });

        queue.push(`${JSON.stringify(record)}\n`);
      }
    } catch (err) {
      console.error('Unable to parse string', msg);
      console.error(err);
    }
  })
  .on('end', () => {
    done = true;
    writeQueue();
  });
