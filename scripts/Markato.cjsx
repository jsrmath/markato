React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'
S = require 'string'
parser = require './parser'
transpose = require './transpose'
Switches = require './Switches'
MarkatoOutput = require './MarkatoOutput'
MarkatoInput = require './MarkatoInput'
EditButton = require './EditButton'
ChordAltModal = require './ChordAltModal'
TransposeModal = require './TransposeModal'
TransposeToolbar = require './TransposeToolbar'

example = require './example'

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
    parsedInput: parser.parseString example # Calculate this explicitly to save time
    showChordAltModal: false
    showTransposeModal: false
    chordReplacements: {} # Maps chord to index of alternate
    altsModalChord: null
    altsModalAlts: []

  key: ->
    validKeys = ['C','C#','Db','D','D#','Eb','E','F','F#','Gb','G','G#','Ab','A','A#','Bb','B']
    possibleKeys = [
      @state.parsedInput.meta.KEY,
      @lastInferredChord(),
      @lastDefinedChord(),
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
      chord = @state.parsedInput.alts[chord][@state.chordReplacements[chord]]
    @formatChord chord

  lastInferredChord: ->
    try 
      chord = _.last(_.last(_.last(@props.song.content).lines)).chord
      s11.note.create(chord).clean().name
    catch e
      ''

  lastDefinedChord: ->
    try
      chord = _.last _.last @props.song.chords[_.last @props.song.sections]
      s11.note.create(chord).clean().name
    catch e
      ''

  resetKey: ->
    @setState displayKey: null

  switchState: ->
    _.pick @state, 'showChords', 'showLyrics', 'showFade', 'showSections', 'showAlternates'

  handleInput: (e) ->
    @setState input: e.target.value, parsedInput: parser.parseString e.target.value

  toggleState: (key) ->
    => @setState "#{key}": not @state[key]

  switches: ->
    _.map @switchState(), (value, key) =>
      label: S(key).chompLeft('show').s
      key: key
      value: value
      handleChange: @toggleState key

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
        <div className="jumbotron center">
          <TransposeToolbar displayKey={@displayKey()}
                            showTransposeModal={@toggleState 'showTransposeModal'}
                            setDisplayKey={@setDisplayKey} />
          <Switches switches={@switches()} />
        </div>
      </div>
      <div className="row">
        <div className={if @state.isEditing then "col-md-6" else "col-md-12"}>
          <EditButton isEditing={@state.isEditing} handleClick={@toggleState 'isEditing'} />
          <MarkatoOutput song={@state.parsedInput}
                         switches={@switchState()}
                         displayKey={@displayKey()}
                         showChordAltModal={@showChordAltModal}
                         chordReplacements={@state.chordReplacements}
                         formatChordWithAlts={@formatChordWithAlts}
                         playback={not @state.isEditing}
                         play={@props.play} />
        </div>
        {<div className="col-md-6">
          <MarkatoInput input={@state.input}
                        handleInput={@handleInput} />
        </div> if @state.isEditing}
      </div>
      <ChordAltModal show={@state.showChordAltModal}
                     onHide={@toggleState 'showChordAltModal'}
                     chord={@state.altsModalChord}
                     alts={@state.parsedInput.alts[@state.altsModalChord]}
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
