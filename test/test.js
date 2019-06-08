const assert = require('assert');
const MultiWriteable = require('../lib/multi-writable');


const COMMAND_EXEC_BUFF = Buffer.from(';');


describe('MultiWriteable stream', () => {
  it('should be an object', () => {
    const writable = new MultiWriteable();
    assert.equal(typeof writable, 'object');
  });

  it('should find end of line', () => {
    const writable = new MultiWriteable();
    const testString = 'Something something ; Something something ;';

    writable.buffer = Buffer.from(testString);

    const indexOfFirstSemi = testString.indexOf(';');
    const end = writable.skipToEndOfCommand();

    assert.equal(end[0], COMMAND_EXEC_BUFF[0]);
    assert.equal(writable.buffer[writable.bufferPosition - 1], COMMAND_EXEC_BUFF[0]);
    assert.equal(writable.bufferPosition, indexOfFirstSemi + 1);
  });

  it('should have undefined end of line when no semicolon', () => {
    const writable = new MultiWriteable();
    const testString = 'Something \'something Something;\' something';

    writable.buffer = Buffer.from(testString);

    const end = writable.skipToEndOfCommand();

    assert.equal(end, undefined);
    assert.equal(writable.bufferPosition, writable.buffer.length);
  });

  it('should find contents in braces', () => {
    const writable = new MultiWriteable();
    const strA = 'Something something 1';
    const strB = 'Something \'(something) 2\'';
    const testString = `(${strA}),(${strB});`;

    writable.buffer = Buffer.from(testString);

    const partA = writable.getNextCommandParenSet();
    const partB = writable.getNextCommandParenSet();
    const end = writable.skipToEndOfCommand();

    assert.equal(partA.toString(), strA);
    assert.equal(partB.toString(), strB);
    assert.equal(writable.bufferPosition, writable.buffer.length);

    assert.equal(writable.buffer[writable.bufferPosition - 1], COMMAND_EXEC_BUFF[0]);
    assert.equal(writable.bufferPosition, writable.buffer.length);
    assert.equal(end[0], COMMAND_EXEC_BUFF[0]);
  });

  it('should clean buffer', () => {
    const writable = new MultiWriteable();
    const testString = 'Something \'something Something;\' something';
    const testOffset = 5;
    writable.buffer = Buffer.from(testString);

    const bufferLength = writable.buffer.length;
    writable.bufferPosition = bufferLength;
    writable.cleanBuffer();

    assert.equal(writable.buffer.length, 0);
    assert.equal(writable.bufferPosition, 0);

    writable.buffer = Buffer.from(testString);
    writable.bufferPosition = testOffset;
    writable.cleanBuffer();

    assert.equal(writable.buffer.length, bufferLength - testOffset);
    assert.equal(writable.bufferPosition, 0);

    writable.buffer = Buffer.from(testString);
    writable.cleanBuffer();

    assert.equal(writable.buffer.length, bufferLength);
    assert.equal(writable.bufferPosition, 0);
  });
});
