const fs = require('fs');
const path = require('path');
const mkdirp = require('mkdirp');


function writeToStdout(content) {
  return new Promise((resolve) => {
    process.stdout.write(content, resolve);
  });
}


function writeToFileDir({
  directory,
  filename,
  content,
  append = false,
}) {
  const write = append ? fs.appendFile : fs.writeFile;
  const formattedDir = path.format({ dir: directory });
  const normalizedDir = path.normalize(formattedDir);

  return new Promise((resolve, reject) => {
    mkdirp(normalizedDir, (mkdirError) => {
      if (mkdirError) { reject(mkdirError); }

      const filepath = `${normalizedDir}/${filename}`;

      write(filepath, content, (writeError) => {
        if (writeError) {
          console.error('Error writing to file:', filepath);
          console.error(writeError);
        }

        resolve();
      });
    });
  });
}

function createWriteFileStream({ directory, filename }) {
  const formattedDir = path.format({ dir: directory });
  const normalizedDir = path.normalize(formattedDir);
  const filepath = `${normalizedDir}/${filename}`;
  const stream = fs.createWriteStream(filepath);

  mkdirp.sync(normalizedDir);

  return stream;
}


module.exports = {
  writeToFileDir,
  writeToStdout,
  createWriteFileStream,
};
