React = require 'react'
_ = require 'underscore'
s11 = require 'sharp11'

chordSymbolMap = 
  'M': ''
  'm': 'm'
  '+': 'aug'
  'aug': 'aug'
  'dim': 'dim'
  '7': '7'
  'm7': 'm7'
  'M7': 'maj7'
  '6': '6'
  'm6': 'm6'
  'add9': 'add9'
  '9': '9'
  'm9': 'm9'
  'sus2': 'sus2'
  'sus4': 'sus4'
  '7sus4': '7sus4'
  'sus47': 'sus47'

module.exports = React.createClass
  chordCharts: ->
    _.filter _.map @chords(), (chord) =>
      try
        note = s11.note.extract(chord).withAccidental('b').name
        symbol = chordSymbolMap[s11.chord.create(chord).symbol]
        if symbol?
          <div className="ukulele-chord" key={chord}>
            <div className="ukulele-chord-name">{chord}</div>
            <img src="https://ukuchords.com/chords/#{note}/#{note}#{symbol}.png" />
          </div>
      catch err
        null

  chords: ->
    chordList = _.flatten _.values @props.song.chords
    chordList = _.map chordList, @props.formatChordWithAlts if @props.formatChordWithAlts
    _.uniq chordList

  render: ->
    <div className="ukulele">
      <div className="section-header">Ukulele Chords<hr /></div>
      {@chordCharts()}
    </div>