const Benchmark = require('benchmark');

const suite = new Benchmark.Suite();

const obj = {
  nested: {
    something: 'blah blah',
    sett: ['something', 'something'],
    num: 287281376,
  },
};

// add tests

suite

  /* eslint-disable */
  .add('Basic all', () => {
    const something = obj.nested.something;
    const sett = obj.nested.sett;
    const num = obj.nested.num;
  })

  .add('Single deconstruction', () => {
    const { nested } = obj;
    const something = nested.something;
    const sett = nested.sett;
    const num = nested.num;
  })

  .add('Double deconstruction', () => {
    const { nested } = obj;
    const { something, sett, num } = nested
  })
  /* eslint-enable */

  // add listeners
  .on('cycle', (event) => {
    console.log(String(event.target));
  })

  .on('complete', function completionMessage() {
    console.log(`Fastest is ${this.filter('fastest').map('name')}`);
  })

  // run async
  .run({ async: false });
