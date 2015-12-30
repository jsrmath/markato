var parser = require('../lib/parser');
var assert = require('assert');

describe('Parser', function () {
  describe('#parseMarkatoString', function () {
    it('should return an object', function () {
      assert(parser.parseMarkatoString('foo'));
    });
  });
});