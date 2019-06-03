const fs = require('fs');

const JSON5 = require('json5');
const split = require('split');


const queue = [];
const config = { };
const schema = {};


const writeQueue = () => {
  const { outputDir, workerPart } = config;
  const writeRows = queue.splice(0, queue.length);
  const writeString = writeRows.join('');
  const partID = workerPart !== undefined ? workerPart : process.pid;

  if (writeString) {
    if (outputDir) {
      fs.mkdir(outputDir, { recursive: true }, (mkdirErr) => {
        if (mkdirErr) {
          throw mkdirErr;
        }

        const filename = `${outputDir}/${schema.name}_${partID}.json`;

        fs.appendFile(filename, writeString, (appendError) => {
          if (appendError) {
            console.error('Error in process', partID);
            console.error(appendError);
          }
        });
      });
    } else {
      process.stdout.write(`${writeString}\n`);
    }
  }
};

const inter = setInterval(writeQueue, 1000);

process
  .stdin
  .pipe(split())
  .on('data', (data) => {
    const msg = data.toString();

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
  .on('close', () => {
    writeQueue();
    clearInterval(inter);
    process.exit();
  });
