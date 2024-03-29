const assert = require('assert');
const { SQLBuffer } = require('../lib/sql-buffer');

const COMMAND_EXEC_BUFF = Buffer.from(';');

describe('SQLBuffer stream buffer control', () => {
  it('should be an object', () => {
    const buffer = new SQLBuffer();
    assert.equal(typeof buffer, 'object');
  });

  it('should find end of line', () => {
    const buffer = new SQLBuffer();
    const testString = 'Something something ; Something something ;';

    buffer.add(Buffer.from(testString));

    const indexOfFirstSemi = testString.indexOf(';');
    const end = buffer.skipToEndOfCommand();

    assert.equal(end[0], COMMAND_EXEC_BUFF[0]);
    assert.equal(buffer.position - 1, indexOfFirstSemi);
    assert.equal(buffer.buffer[buffer.position - 1], COMMAND_EXEC_BUFF[0]);
  });

  it('should have undefined end of line when no semicolon', () => {
    const buffer = new SQLBuffer();
    const testString = 'Something \'something Something;\' something';

    buffer.add(Buffer.from(testString));

    const end = buffer.skipToEndOfCommand();

    assert.equal(end, undefined);
    assert.equal(buffer.position, buffer.length);
  });

  it('should find contents in braces', () => {
    const buffer = new SQLBuffer();
    const strA = 'Something something 1';
    const strB = 'Something \'(something) 2\'';
    const testString = `(${strA}),(${strB});`;

    buffer.add(Buffer.from(testString));

    const partA = buffer.getNextCommandParenSet();
    const partB = buffer.getNextCommandParenSet();

    assert.equal(partA.toString(), `[${strA}]\n`);
    assert.equal(partB.toString(), `[${strB}]\n`);
    assert.equal(buffer.position, buffer.length - 1);

    const end = buffer.skipToEndOfCommand();

    assert.equal(buffer.buffer[buffer.position - 1], COMMAND_EXEC_BUFF[0]);
    assert.equal(buffer.position, buffer.length);
    assert.equal(end[0], COMMAND_EXEC_BUFF[0]);
  });

  it('should clean buffer', () => {
    const buffer = new SQLBuffer();
    const testString = 'Something \'something Something;\' something';
    const testOffset = 5;
    buffer.buffer = Buffer.from(testString);

    const bufferLength = buffer.length;
    buffer.position = bufferLength;
    buffer.clean();

    assert.equal(buffer.length, 0);
    assert.equal(buffer.position, 0);

    buffer.buffer = Buffer.from(testString);
    buffer.position = testOffset;
    buffer.clean();

    assert.equal(buffer.length, bufferLength - testOffset);
    assert.equal(buffer.position, 0);

    buffer.buffer = Buffer.from(testString);
    buffer.clean();

    assert.equal(buffer.length, bufferLength);
    assert.equal(buffer.position, 0);
  });

  it('should find sub-buffer index', () => {
    const buffer = new SQLBuffer();
    const searchString = 'CREATE TABLE';
    const testString = `
        -- something CREATE TABLE
        Something 'CREATE TABLE \`somethingwrong\` ();'
        /* blah CREATE TABLE
         another CREATE TABLE
        */ CREATE TABLE \`somethingright\` (
    `;

    const firstIndexOf = testString.indexOf(searchString);
    const secondIndexOf = testString.indexOf(searchString, firstIndexOf + 1);
    const thirdIndexOf = testString.indexOf(searchString, secondIndexOf + 1);
    const fourthIndexOf = testString.indexOf(searchString, thirdIndexOf + 1);
    const fifthIndexOf = testString.indexOf(searchString, fourthIndexOf + 1);

    buffer.add(Buffer.from(testString));

    assert.equal(buffer.indexOf(Buffer.from(searchString)), firstIndexOf);
    assert.equal(buffer.indexOf(Buffer.from(searchString), undefined, false), fifthIndexOf);
    assert.equal(buffer.position, 0);
  });
});
