// parser.js - Julian Rosenblum
// Parses Markato files into Markato object
// Dependencies: underscore.js, string.js

var parser = (function () {
  var parseFooterStartLine = function (state, line) {
    state.current.footer = true;
    return state;
  };

  var parseMetaLine = function (state, line) {
    var prefix = line.split(' ')[0];
    var metaName = prefix.slice(2); // Remove ##
    var metaValue = S(line).chompLeft(prefix).trim().s;

    state.meta[metaName] = metaValue;
    return state;
  };

  var parseSectionLine = function (state, line) {
    var sectionName = S(line.slice(1)).trim().s; // Remove # and trim

    state.current.sectionName = sectionName;

    // It's a new section if we don't already have it on the list
    state.current.newSection = !_.contains(state.sections, sectionName);

    state.current.line = 0;

    state.sections.push(sectionName);
    state.lyrics.push({
      section: sectionName,
      firstTime: state.current.newSection,
      lines: []
    });
    
    if (state.current.newSection) state.chords[sectionName] = [];

    return state;
  };

  var parseChordLine = function (state, line) {
    var chords = S(line.slice(1)).trim().s.split(' '); // Remove : and trim
    var sectionName = state.current.sectionName;

    if (state.current.newSection) {
      state.chords[sectionName].push(chords);
    }

    state.current.lastChords = chords;

    return state;
  };

  var parseFooterLine = function (state, line) {
    var parts = S(line).strip(' ').split('=>');
    var chord;
    var alts;

    if (parts.length !== 2) return state;

    chord = parts[0];
    alts = parts[1].split(',');

    // Add alternates for each chord and remove ' marks
    _.each(state.lyrics, function (section) {
      _.each(section.lines, function (line) {
        _.each(line, function (phrase) {
          if (phrase.chord === chord) {
            phrase.alts = alts;
            phrase.chord = S(phrase.chord).strip('\'').s;
          }
        });
      });
    });

    return state;
  };

  var parseLyricLine = function (state, line) {
    var caratSplit = line.split('^'); // Used to figure out phrases
    var chordIndex = 0; // Index in list of chords as we assemble phrases
    var phrases = [];
    var exceptionIndices = []; // Chord indices that are exceptions in this section

    // Start off by assuming the chords are the current chords in this verse
    var chords = state.chords[state.current.sectionName][state.current.line];

    // If there are no current chords in this verse, add an empty array to the verse
    if (!chords) {
      chords = state.chords[state.current.sectionName][state.current.line] = [];
    }

    // If we're not in a new section and we just saw a line of chords, this means
    // substitutions are being made in this section
    if (!state.current.isNew && state.current.lastChords) {
      chords = _.map(state.current.lastChords, function (chord, index) {
        // For *, get the chord at the same index from the chord list
        if (chord === '*') return chords[index];

        exceptionIndices.push(index);
        return chord;
      });
    }

    _.each(caratSplit, function (phrase, index) {
      var addPhrase = function (obj) {
        phrases.push(_.defaults(obj, {
          string: '',
          chord: '',
          exception: false,
          alts: [],
          wordExtension: false
        }));
      };

      var chord;
      var lastPhrase;

      // Special case first phrase
      if (index === 0) {
        if (phrase) {
          addPhrase({string: caratSplit[0]});
        }
        return;
      }

      lastPhrase = caratSplit[index - 1];

      // Get next chord
      chord = chords[chordIndex];

      // 'foo ^ bar' case, we insert the chord with a blank lyric
      if (phrase && phrase[0] == ' ') {
        addPhrase({
          chord: chord,
          exception: _.contains(exceptionIndices, chordIndex)
        });

        addPhrase({
          string: S(phrase).trim().s,
        });
      }
      else {
        addPhrase({
          string: S(phrase).trim().s,
          chord: chord,
          exception: _.contains(exceptionIndices, chordIndex),
        });
      }

      // Check for foo^bar case (doesn't start with space and last phrase doesn't end with one)
      if (phrase && phrase[0] !== ' ' && lastPhrase && S(lastPhrase).right(1).s !== ' ') {
        _.last(phrases).wordExtension = true;
      }

      chordIndex += 1;
    });
    
    // Add new line to current lyric section
    _.last(state.lyrics).lines.push(phrases);

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

    if (state.current.footer) return parseFooterLine(state, line);

    return parseLyricLine(state, line);
  };

  // Given a finished parse state, return a markato object
  var markatoObjectFromState = function (state) {
    return _.omit(state, 'current');
  };

  // Parses a string of Markato and returns a Markato object
  return {
    parseString: function (str) {
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
    }
  };
}());