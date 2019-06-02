const JSON5 = require('json5');

let schema;

process.on('message', (msg) => {
  const parsed = JSON5.parse(msg);

  if (parsed.name) {
    schema = parsed;
    // console.log('schema', JSON.stringify(schema));
  } else if (Array.isArray(parsed)) {
    const record = {};

    parsed.forEach((val, i) => {
      const key = schema.columns[i].name;
      record[key] = val;
    });

    // console.log(JSON.stringify(record));
    process.send(JSON.stringify(record));
  }
});
