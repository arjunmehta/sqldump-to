const split = require('split');
const JSON5 = require('json5');

process.stdin
  .pipe(split('),('))
  .on('data', (data) => {
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

        console.log(schema);
      }
    }

    // if (hasBeg.length > 1 || hasEnd.length > 1) {
    //   console.log({
    //     hasBeg: hasBeg.length,
    //     hasEnd: hasEnd.length,
    //   });
    // }

    const record = JSON5.parse(`[${str}]`);
    console.log(JSON.stringify(record));
  })
  .on('close', () => {
    console.log('Done');
  });
