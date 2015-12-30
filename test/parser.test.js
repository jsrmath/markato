var parser = require('../lib/parser');
var assert = require('assert');

describe('Parser', function () {
  describe('#parseString', function () {
    it('should return an object', function () {
      assert(parser.parseString(''));
    });
  });
});