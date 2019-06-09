const fs = require('fs');
const path = require('path');
const mkdirp = require('mkdirp');


function writeToFileDir({
  directory,
  filename,
  content,
  append = false,
}, done = () => {}) {
  const write = append ? fs.appendFile : fs.writeFile;

  mkdirp(directory, (mkdirError) => {
    if (mkdirError) { throw mkdirError; }

    const formattedDir = path.format({ dir: directory });
    const normalizedDir = path.normalize(formattedDir);
    const filepath = `${normalizedDir}/${filename}`;

    write(filepath, content, (writeError) => {
      if (writeError) {
        console.error('Error writing to file:', filepath);
        console.error(writeError);
      }

      done();
    });
  });
}


module.exports = {
  writeToFileDir,
};
