React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'
S = require 'string'
parser = require './parser'
Switches = require './Switches'
MarkatoOutput = require './MarkatoOutput'
MarkatoInput = require './MarkatoInput'
EditButton = require './EditButton'
ChordAltModal = require './ChordAltModal'

module.exports = React.createClass
  getInitialState: ->
    isEditing: true
    showChords: true
    showLyrics: true
    showFade: true
    showSections: true
    showAlternates: true
    displayKey: ''
    input: require './example'
    showChordAltModal: false
    chordReplacements: {} # Maps chord to index of alternate
    altsModalChord: ''
    altsModalAlts: []

  switchState: ->
    _.pick @state, 'showChords', 'showLyrics', 'showFade', 'showSections', 'showAlternates'

  handleInput: (e) ->
    @setState input: e.target.value

  parsedInput: ->
    parser.parseString @state.input

  toggleState: (key) ->
    => @setState "#{key}": not @state[key]

  switches: ->
    _.map @switchState(), (value, key) =>
      label: S(key).chompLeft('show').s
      key: key
      value: value
      handleChange: @toggleState key

  showChordAltModal: (chord) ->
    =>
      @setState showChordAltModal: true, altsModalChord: chord

  selectAlt: (index) ->
    =>
      chordReplacements = @state.chordReplacements
      chordReplacements[@state.altsModalChord] = index
      @setState chordReplacements: chordReplacements, showChordAltModal: false

  render: ->
    <div className="container">
      <div className="row">
        <div className="jumbotron center">
          <Switches switches={@switches()} />
        </div>
      </div>
      <div className="row">
        <div className={if @state.isEditing then "col-md-6" else "col-md-12"}>
          <EditButton isEditing={@state.isEditing} handleClick={@toggleState 'isEditing'} />
          <MarkatoOutput song={@parsedInput()}
                         switches={@switchState()}
                         displayKey={@state.displayKey}
                         showChordAltModal={@showChordAltModal}
                         chordReplacements={@state.chordReplacements} />
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
                     selectAlt={@selectAlt} />
    </div>
