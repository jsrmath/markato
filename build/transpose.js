var S, s11, trimChord;

S = require('string');

s11 = require('sharp11');

trimChord = function(chord) {
  var matches;
  matches = chord.match(/^[A-G][#b]?/);
  if (!matches) {
    throw new Error('Invalid chord name ' + chord);
  }
  return matches[0];
};

module.exports = function(origKey, newKey, chord) {
  var interval, note;
  interval = s11.note.create(origKey).getInterval(newKey);
  note = trimChord(chord);
  chord = S(chord).chompLeft(note).s;
  note = s11.note.create(note).transpose(interval).clean();
  return note.name + chord;
};
