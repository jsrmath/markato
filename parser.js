// parser.js - Julian Rosenblum
// Parses Markato files into Markato object
// Dependencies: underscore.js, string.js

var parser = (function () {
  var isChordLine = function (line) {
    return S(line).startsWith(':');
  }

  var preParseFooterStartLine = function (state, line) {
    state.current.footer = true;
    return state;
  };

  var preParseMetaLine = function (state, line) {
    var prefix = line.split(' ')[0];
    var metaName = prefix.slice(2); // Remove ##
    var metaValue = S(line).chompLeft(prefix).trim().s;

    state.meta[metaName] = metaValue;
    return state;
  };

  var preParseFooterLine = function (state, line) {
    var parts = S(line).strip(' ').split('=>');
    var chord;
    var alts;

    if (parts.length !== 2) return state;

    chord = parts[0];
    alts = parts[1].split(',');

    state.alts[chord] = alts;
    return state;
  };

  var preParseTextLine = function (state, line) {
    var lastLine = state.lines.length ? _.last(state.lines) : null;

    // If we have a section header
    if (S(line).startsWith('#')) {
      state.lines.push({
        type: 'section',
        name: S(line.slice(1)).trim().s
      });
    }

    // If we have a chord line
    else if (isChordLine(line)) {
      state.lines.push({
        type: 'lyricChord',
        chords: S(line.slice(1)).trim().s.split(' '),
        lyrics: ''
      });
    }

    // If we have a lyric line
    else {
      // If last line is a chord line, add lyrics to it
      if (lastLine && lastLine.type === 'lyricChord' && !lastLine.lyrics) {
        lastLine.lyrics = line;
        return state;
      }
      // Otherwise, we have a solitary line of lyrics
      else {
        state.lines.push({
          type: 'lyricChord',
          chords: [],
          lyrics: line
        });
      }
    }

    return state;
  };

  // Given a preparse state, preparses a line of Markato and returns updated state
  var preParseLine = function (state, line) {
    // Remove extraneous whitespace
    line = S(line).trim().collapseWhitespace().s;

    if (!line) return state;

    if (S(line).startsWith('###')) return preParseFooterStartLine(state, line);

    if (S(line).startsWith('##')) return preParseMetaLine(state, line);

    if (state.current.footer) return preParseFooterLine(state, line);

    return preParseTextLine(state, line);
  };

  var addSection = function (state, sectionName) {
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


  var addLyricChord = function (state, lyrics, chords) {
    var sectionName = state.current.sectionName;
    var caratSplit = lyrics.split('^'); // Used to figure out phrases
    var chordIndex = 0; // Index in list of chords as we assemble phrases
    var phrases = [];
    var exceptionIndices = []; // Chord indices that are exceptions in this section
    var sectionChords;

    var addPhrase = function (obj) {
      obj = _.defaults(obj, {
        string: '',
        chord: '',
        exception: false,
        wordExtension: false
      });

      // Fetch alternates
      obj.alts = state.alts[obj.chord] || [];
      obj.chord = S(obj.chord).strip('\'').s;

      phrases.push(obj);
    };

    // If we're not in a section, create one called untitled
    if (sectionName === null) {
      sectionName = 'UNTITLED'
      state = addSection(state, sectionName);
    }

    // If this is a new section, add the chords to that section
    if (state.current.newSection) {
      state.chords[sectionName].push(chords);
    }

    // Get the chords stored for the section
    sectionChords = state.chords[sectionName][state.current.line];

    // If there is no above line of chords, use the section chords
    if (!chords.length) chords = sectionChords

    // Substitute * from sectionChords where necessary
    chords = _.map(chords, function (chord, index) {
      // For *, get the chord at the same index from the chord list
      if (chord === '*') return sectionChords[index];

      exceptionIndices.push(index);
      return chord;
    });

    // If there are no lyrics, just add a line of chords
    if (!lyrics) {
      _.each(chords, function (chord) {
        addPhrase({chord: chord});
      });
    }
    // Otherwise, add lyrics based on carats
    else {
      _.each(caratSplit, function (phrase, index) {
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
    }
    
    // Add new line to current lyric section
    _.last(state.lyrics).lines.push(phrases);

    state.current.line += 1;
    return state;
  };

  // Given a parse state, parses a line of Markato and returns updated state
  var parseLine = function (state, line) {
    if (line.type === 'section') return addSection(state, line.name);

    if (line.type === 'lyricChord') return addLyricChord(state, line.lyrics, line.chords);

    return state; // Should not ever reach this
  };

  // Given a finished parse state, return a markato object
  var markatoObjectFromState = function (state) {
    return _.omit(state, 'current');
  };

  // Parses a string of Markato and returns a Markato object
  return {
    parseString: function (str) {
      var lines = S(str).lines();
      var preParseState = {
        current: {
          footer: false // Are we in the footer?
        },
        meta: {},
        alts: {},
        lines: []
      };
      var parseState = {
        current: {
          sectionName: null, // Current section we're in
          newSection: true, // Is this a section being newly defined?
          line: 0 // What line of the section are we in (incremented on parseLyric)
        },
        sections: [],
        chords: {},
        lyrics: []
      };

      // Run preparser
      preParseState = _.reduce(lines, preParseLine, preParseState);

      // Extract relevant information from preParseState
      parseState.meta = preParseState.meta;
      parseState.alts = preParseState.alts;

      parseState = _.reduce(preParseState.lines, parseLine, parseState);
      return markatoObjectFromState(parseState);
    }
  };
}());