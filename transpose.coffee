# transpose.coffee - Julian Rosenblum
# Given an original key and a new key, transpose a given note

S = require 'string'
s11 = require 'sharp11'

trimChord = (chord) ->
  matches = chord.match /^[A-G][#b]?/

  if not matches
    throw new Error('Invalid chord name ' + chord)

  matches[0]

module.exports = (origKey, newKey, chord) ->
  interval = s11.note.create(origKey).getInterval(newKey)

  note = trimChord chord
  chord = S(chord).chompLeft(note).s

  # Transpose and concatenate
  note = s11.note.create(note).transpose(interval).clean()

  note.name + chord
