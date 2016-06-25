React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'
S = require 'string'
memoize = require 'memoizee'
parser = require './parser'
transpose = require './transpose'
Switches = require './Switches'
MarkatoOutput = require './MarkatoOutput'
MarkatoInput = require './MarkatoInput'
EditButton = require './EditButton'
ChordAltModal = require './ChordAltModal'
TransposeModal = require './TransposeModal'

example = require './example'

parsedInput = memoize parser.parseString, primitive: true

module.exports = React.createClass
  getInitialState: ->
    isEditing: true
    showChords: true
    showLyrics: true
    showFade: true
    showSections: true
    showAlternates: true
    displayKey: null
    input: example
    showChordAltModal: false
    showTransposeModal: false
    chordReplacements: {} # Maps chord to index of alternate
    altsModalChord: null
    altsModalAlts: []

  parsedInput: ->
    parsedInput @state.input

  key: ->
    validKeys = ['C','C#','Db','D','D#','Eb','E','F','F#','Gb','G','G#','Ab','A','A#','Bb','B']
    possibleKeys = [
      @parsedInput().meta.KEY,
      @lastChord(),
      'C'
    ]
    #return first from possibleKeys where key is in validKeys
    _.find possibleKeys, (key) -> key in validKeys

  displayKey: ->
    @state.displayKey or @key()

  formatChord: (chord) ->
    if chord
      transpose(@key(), @displayKey(), chord).replace(/'/g, '')

  formatChordWithAlts: (chord) ->
    if @state.chordReplacements[chord]?
      chord = @parsedInput().alts[chord][@state.chordReplacements[chord]]
    @formatChord chord

  lastChord: ->
    try
      chords = _.flatten _.pluck @parsedInput().content, 'lines'
      _.last(chords).chord
    catch err
      ''

  resetKey: ->
    @setState displayKey: null

  switchState: ->
    _.pick @state, 'showChords', 'showLyrics', 'showFade', 'showSections', 'showAlternates'

  handleInput: (e) ->
    @setState input: e.target.value

  toggleState: (key) ->
    => @setState "#{key}": not @state[key]

  switches: ->
    _.map @switchState(), (value, key) =>
      label: S(key).chompLeft('show').s
      key: key
      active: value
      handleClick: @toggleState key

  selectAlt: (index) ->
    =>
      chordReplacements = @state.chordReplacements
      chordReplacements[@state.altsModalChord] = index
      @setState chordReplacements: chordReplacements, showChordAltModal: false

  setDisplayKey: (key) ->
    =>
      @setState displayKey: key, showTransposeModal: false

  showChordAltModal: (chord) ->
    @setState showChordAltModal: true, altsModalChord: chord

  render: ->
    <div className="container">
      <div className="row">
        <div className={if @state.isEditing then "col-md-6" else "col-md-12"}>
          <EditButton isEditing={@state.isEditing} handleClick={@toggleState 'isEditing'} />
          <Switches switches={@switches()} />
          <MarkatoOutput song={@parsedInput()}
                         switches={@switchState()}
                         displayKey={@displayKey()}
                         showChordAltModal={@showChordAltModal}
                         chordReplacements={@state.chordReplacements}
                         formatChordWithAlts={@formatChordWithAlts}
                         playback={not @state.isEditing}
                         play={@props.play}
                         showTransposeModal={@toggleState 'showTransposeModal'}
                         setDisplayKey={@setDisplayKey} />
        </div>
        {<div className="col-md-6">
          <MarkatoInput input={@state.input}
                        handleInput={@handleInput} />
        </div> if @state.isEditing}
      </div>
      <ChordAltModal show={@state.showChordAltModal}
                     onHide={@toggleState 'showChordAltModal'}
                     chord={@state.altsModalChord}
                     alts={@parsedInput().alts[@state.altsModalChord]}
                     selected={@state.chordReplacements[@state.altsModalChord]}
                     selectAlt={@selectAlt}
                     formatChord={@formatChord} />
      <TransposeModal show={@state.showTransposeModal}
                      onHide={@toggleState 'showTransposeModal'}
                      displayKey={@displayKey()}
                      originalKey={@key()}
                      setDisplayKey={@setDisplayKey}
                      reset={@resetKey} />
    </div>
