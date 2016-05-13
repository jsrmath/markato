var s11;

s11 = require('sharp11');

module.exports = function(origKey, newKey, chordStr) {
  var chord, interval, newNote;
  chord = s11.chord.create(chordStr);
  interval = s11.note.create(origKey).getInterval(newKey);
  newNote = chord.root.transpose(interval).clean();
  return chordStr.replace(new RegExp('^' + chord.root), newNote);
};
