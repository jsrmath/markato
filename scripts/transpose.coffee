# transpose.coffee - Julian Rosenblum
# Given an original key and a new key, transpose a given note

s11 = require 'sharp11'

module.exports = (origKey, newKey, chordStr) ->
  try
    chord = s11.chord.create(chordStr)
    interval = s11.note.create(origKey).getInterval(newKey)
    newNote = chord.root.transpose(interval).clean()

    chordStr.replace(new RegExp('^' + chord.root), newNote)
  catch err
    chordStr
