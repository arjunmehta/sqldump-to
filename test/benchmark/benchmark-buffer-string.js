const Benchmark = require('benchmark');

const suite = new Benchmark.Suite();

const rowContent = Buffer.from('275,18762,\'asdjgasdgasdkjgaskjdhg\',2872,\'jkhgasdkjhag8273tejkhasdjkha2837teja\'');
const rowContentWithBraces = Buffer.from('(275,18762,\'asdjgasdgasdkjgaskjdhg\',2872,\'jkhgasdkjhag8273tejkhasdjkha2837teja\')');
const rowContentWithBracesComma = Buffer.from('(275,18762,\'asdjgasdgasdkjgaskjdhg\',2872,\'jkhgasdkjhag8273tejkhasdjkha2837teja\'),');
const bracketOpen = Buffer.from('[');
const bracketClose = Buffer.from(']');
const newLine = Buffer.from('\n');
const bracketCloseWithNewline = Buffer.from(']\n');

const bracketOpenOct = Buffer.from('[')[0];
const bracketCloseOct = Buffer.from(']')[0];
const newlineOct = Buffer.from('\n')[0];

// add tests
suite
  .add('Coerce to string convert Buffer', () => {
    Buffer.from(`[${rowContent.slice()}]\n`);
  })

  .add('Concat Buffers', () => {
    Buffer.concat([bracketOpen, rowContent.slice(), bracketClose, newLine]);
  })

  .add('Concat Buffers with integrated newline', () => {
    Buffer.concat([bracketOpen, rowContent.slice(), bracketCloseWithNewline]);
  })

  .add('Replace braces with brackets + concat newline', () => {
    const newBuffer = rowContentWithBraces.slice();
    newBuffer[0] = bracketOpenOct;
    newBuffer[newBuffer.length - 1] = bracketCloseOct;
    Buffer.concat([newBuffer, newLine]);
  })

  .add('Replace braces & comma with brackets & newline', () => {
    const newBuffer = rowContentWithBracesComma.slice();
    newBuffer[0] = bracketOpenOct;
    newBuffer[newBuffer.length - 2] = bracketCloseOct;
    newBuffer[newBuffer.length - 1] = newlineOct;
  })

  .add('allocUnsafe buffer', () => {
    const newBuffer = Buffer.allocUnsafe(rowContent.length + 3);
    rowContent.copy(newBuffer, 1);
    newBuffer[0] = bracketOpenOct;
    newBuffer[newBuffer.length - 2] = bracketCloseOct;
    newBuffer[newBuffer.length - 1] = newlineOct;
  })

  .add('alloc buffer', () => {
    const newBuffer = Buffer.alloc(rowContent.length + 3);
    rowContent.copy(newBuffer, 1);
    newBuffer[0] = bracketOpenOct;
    newBuffer[newBuffer.length - 2] = bracketCloseOct;
    newBuffer[newBuffer.length - 1] = newlineOct;
  })

  // add listeners
  .on('cycle', (event) => {
    console.log(String(event.target));
  })

  .on('complete', function completionMessage() {
    console.log(`Fastest is ${this.filter('fastest').map('name')}`);
  })

  // run async
  .run({ async: false });
