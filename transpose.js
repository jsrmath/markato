// transpose.js - Julian Rosenblum
// Given an original key and a new key, transpose a given note
// Dependencies: string.js

var trimChord = function (chord) {
  var matches = chord.match(/^[A-G][#b]?/);

  if (!matches) {
    throw new Error('Invalid chord name ' + chord);
  }

  return matches[0];
};

var transpose = function (origKey, newKey, chord) {
  var interval = createNote(origKey).getInterval(newKey);
  var note;

  note = trimChord(chord);
  chord = S(chord).chompLeft(note).s;

  // Transpose and concatenate
  note = createNote(note).transpose(interval).clean();
  return note.name + chord;
};