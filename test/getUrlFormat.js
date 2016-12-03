const assert = require('chai').assert;
const getUrlFormat = require('../src/utils/getUrlFormat.js');

const tests = new Map()
  .set('replacements', ['Ščíťäňie', 'scitanie'])
  .set('spaces',       ['This has spaces', 'this-has-spaces'])
  .set('both prev.',   ['Bešť ôkŇo čäkä', 'best-okno-caka'])
  .set('collapse multiple replacements',
    [' Hello! Is it me,   youre looking for?',
     '-hello-is-it-me-youre-looking-for-'
    ]
  )

describe('String modification to URL format: ', function() {
  for(let [label, test] of tests){
    it(`should cover ${label}`, function() {
      assert.equal(getUrlFormat(test[0]), test[1], '');
    });
  }
});