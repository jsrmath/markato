// parser.js - Julian Rosenblum
// Parses Markato files into Markato object

var _ = require('underscore');
var S = require('string');

var parseFooterStartLine = function (state, line) {
  return state;
};

var parseMetaLine = function (state, line) {
  return state;
};

var parseSectionLine = function (state, line) {
  return state;
};

var parseChordLine = function (state, line) {
  return state;
};

var parseFooterLine = function (state, line) {
  return state;
};

var parseLyricLine = function (state, line) {
  return state;
};

// Given a parse state, parses a line of Markato and returns updated state
var parseLine = function (state, line) {
  // Remove extraneous whitespace
  line = S(line).trim().collapseWhitespace().s;

  if (!line) return state;

  if (S(line).startsWith('###')) return parseFooterStartLine(state, line);

  if (S(line).startsWith('##')) return parseMetaLine(state, line);

  if (S(line).startsWith('#')) return parseSectionLine(state, line);

  if (S(line).startsWith(':')) return parseChordLine(state, line);

  if (state.footer) return parseFooterLine(state, line);

  return parseLyricLine(state, line);
};

// Parses a string of Markato and returns a Markato object
module.exports.parseMarkatoString = function (str) {
  var lines = S(str).lines();

  return _.reduce(lines, parseLine, {obj: {}}).obj;
};