module.exports = {
  extends: 'airbnb-base',
  rules: {
    semi: ['error', 'always'],
    quotes: ['error', 'single'],
    'no-use-before-define': ['error', { 'functions': false }],
    'no-underscore-dangle': 1
  }
};
