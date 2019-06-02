const split = require('split');
const { fork } = require('child_process');
const heartbeats = require('heartbeats');

const heart = heartbeats.createHeart(1000);
const pulse = heart.createPulse();
const numWorkers = 12;
const workers = [];


heart.createEvent(1, () => {
  if (pulse.missedBeats > 2) {
    killWorkers();
  }
});

process.stdin.setEncoding('binary');


for (let i = 0; i < numWorkers; i += 1) {
  workers[i] = fork('cluster-worker.js')
    .on('message', (msg) => {
      console.log(msg);
      pulse.beat();
    })
    .on('error', (err) => {
      throw err;
    });
}

let currentLine = 0;

process.stdin
  .pipe(split('),('))
  .on('data', (data) => {
    const j = currentLine % numWorkers;
    currentLine += 1;

    let str = data.toString('binary');
    const hasBeg = str.split('` VALUES (');
    const hasEnd = str.split(');\n');

    if (hasEnd.length > 1) {
      [str] = hasEnd;
    } else if (hasBeg.length > 1) {
      let beginning;
      [beginning, str] = hasBeg;

      const matches = beginning.match(/CREATE TABLE([^]*?);/);

      if (matches && matches.length > 1) {
        const commands = matches[1].split('\n');
        const schema = {
          name: null,
          columns: [],
        };

        commands.forEach((command, i) => {
          const cleanCommand = command.slice(0, -1).trim();

          if (cleanCommand[0] === '`') {
            const comm = cleanCommand.split(' ');
            const [, name] = comm[0].match(/`([^]*?)`/);

            if (i === 0) {
              schema.name = name;
            } else {
              const type = comm[1];
              const column = { name, type };

              schema.columns.push(column);
            }
          }
        });

        // console.log(schema);
        sendSchema(schema);
      }
    }

    workers[j].send(`[${str}]`);
  })
  .on('close', () => {
    // console.log('Done');
  });

function sendSchema(schema) {
  workers
    .forEach((worker) => {
      worker.send(JSON.stringify(schema));
    });
}

function killWorkers() {
  workers
    .forEach((worker) => {
      worker.kill();
    });

  process.exit();
}
