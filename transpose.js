// transpose.js - Julian Rosenblum
// Given an original key and a new key, transpose a given note
// Dependencies: sharp11.js, string.js

var transpose = function (origKey, newKey, chord) {
  var interval = createNote(origKey).getInterval(newKey);
  var matches;
  var note;

  // Determine root of chord
  matches = chord.match(/^[A-G][#b]?/);

  if (!matches) {
    throw new Error('Invalid chord name ' + chord);
  }

  // Extract note
  note = matches[0];
  chord = S(chord).chompLeft(note).s;

  // Transpose and concatenate
  note = createNote(note).transpose(interval).clean();
  return note.name + chord;
};