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

  return new Promise((resolve, reject) => {
    mkdirp(directory, (mkdirError) => {
      if (mkdirError) { reject(mkdirError); }

      const formattedDir = path.format({ dir: directory });
      const normalizedDir = path.normalize(formattedDir);
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


module.exports = {
  writeToFileDir,
  writeToStdout,
};
