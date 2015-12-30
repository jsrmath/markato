// parser.js - Julian Rosenblum
// Parses Markato files into Markato object

var _ = require('underscore');
var S = require('string');
var fs = require('fs');

var parseFooterStartLine = function (state, line) {
  return state;
};

var parseMetaLine = function (state, line) {
  return state;
};

var parseSectionLine = function (state, line) {
  sectionName = S(line.slice(1)).trim().s;

  state.current.sectionName = sectionName;

  // It's a new section if we don't already have it on the list
  state.current.newSection = !_.contains(state.sections, sectionName);

  state.current.line = 0;

  state.sections.push(sectionName);

  return state;
};

var parseChordLine = function (state, line) {
  var chords = S(line.slice(1)).trim().s.split(' ');
  var sectionName = state.current.sectionName;

  if (state.current.newSection) {
    state.chords[sectionName] = state.chords[sectionName] || [];
    state.chords[sectionName].push(chords);
  }

  state.current.lastChords = chords;

  return state;
};

var parseFooterLine = function (state, line) {
  return state;
};

var parseLyricLine = function (state, line) {
  var chords;

  // Start off by assuming the chords are the current chords in this verse
  chords = state.chords[state.current.sectionName][state.current.line];

  // If we're not in a new section and we just saw a line of chords, this means
  // substitutions are being made in this section
  if (!state.isNew && state.current.lastChords) {
    chords = _.map(state.current.lastChords, function (chord, index) {
      // For *, get the chord at the same index from the chord list
      if (chord === '*') return chords[index];

      return chord;
    });
  }

  state.lyrics.push({lyrics: line, chords: chords});

  // Reset last chords
  state.current.lastChords = null;

  state.current.line += 1;
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

// Given a finished parse state, return a markato object
var markatoObjectFromState = function (state) {
  return state;
};

// Parses a string of Markato and returns a Markato object
var parseString = function (str) {
  var lines = S(str).lines();
  var state = {
    current: {
      sectionName: '', // Current section we're in
      newSection: true, // Is this a section being newly defined?
      line: 0, // What line of the section are we in (incremented on parseLyric)
      footer: false, // Are we in the footer?
      lastChords: null // Array of last line of chords we've seen
    },
    sections: [],
    chords: {},
    lyrics: [],
    meta: {}
  };

  state = _.reduce(lines, parseLine, state);
  return markatoObjectFromState(state);
};

module.exports.parseString = parseString;

module.exports.parseFile = function (path) {
  var file = fs.readFileSync(path);
  return parseString(file);
};