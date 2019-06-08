const fs = require('fs');
const path = require('path');
const mkdirp = require('mkdirp');

const JSON5 = require('json5');
const split = require('split2');


const queue = [];
const config = { };
const schema = {};

function getPartID() {
  const { workerPart } = config;
  const partID = workerPart !== undefined ? workerPart : process.pid;
  return partID;
}


const writeQueue = () => {
  const { outputDir } = config;
  const writeRows = queue.splice(0, queue.length);
  const writeString = writeRows.join('');
  const partID = getPartID();


  if (writeString) {
    if (outputDir) {
      const formattedDir = path.format({ dir: outputDir });
      const normalizedDir = path.normalize(formattedDir);

      mkdirp(outputDir, (mkdirErr) => {
        if (mkdirErr) {
          throw mkdirErr;
        }

        const filename = `${normalizedDir}/${schema.name}_${partID}.json`;

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
    const msg = data.toString().replace(/((?!'[\w\s]*)NULL(?![\w\s]*'))/g, 'null');

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
    console.log('Finished writing part', getPartID());
    writeQueue();
    clearInterval(inter);
    process.exit();
  });
