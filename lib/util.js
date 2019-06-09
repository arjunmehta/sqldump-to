const fs = require('fs');
const path = require('path');
const mkdirp = require('mkdirp');


function writeToFileDir({ directory, filename, content }, done = () => {}) {
  mkdirp(directory, (mkdirError) => {
    if (mkdirError) { throw mkdirError; }

    const formattedDir = path.format({ dir: directory });
    const normalizedDir = path.normalize(formattedDir);
    const filepath = `${normalizedDir}/${filename}`;

    fs.appendFile(filepath, content, (appendError) => {
      if (appendError) {
        console.error('Error writing to file:', filepath);
        console.error(appendError);
      }

      done();
    });
  });
}


module.exports = {
  writeToFileDir,
};
