React = require 'react'
_ = require 'underscore'
S = require 'string'
s11 = require 'sharp11'
audio = require 'sharp11-web-audio'
{ Grid, Row, Col } = require 'react-bootstrap'
DisplaySettings = require './DisplaySettings'
MarkatoOutput = require './MarkatoOutput'
MarkatoInput = require './MarkatoInput'
EditButton = require './EditButton'
DeleteButton = require './DeleteButton'
ShareButton = require './ShareButton'
ChordAltModal = require './ChordAltModal'
TransposeModal = require './TransposeModal'

transpose = (origKey, newKey, chordStr) ->
  try
    interval = s11.note.create(origKey).getInterval(newKey)
    chord = s11.chord.create(chordStr).transpose(interval)
    chord.name
  catch err
    chordStr

module.exports = React.createClass
  getInitialState: ->
    isEditing: not @props.readOnly
    showChordAltModal: false
    showTransposeModal: false
    chordReplacements: {} # Maps chord to index of alternate
    altsModalChord: null
    altsModalAlts: []
    play: null # Lazily load the play function before the component mounts

  componentWillMount: ->
    audio.init (err, fns) =>
      if err then alert err
      @setState play: fns.play

  key: ->
    possibleKeys = [
      @extractKey @props.parsedInput.meta.KEY
      @extractKey @lastChord()
      'C'
    ]
    # Return first from possibleKeys where key is not null
    _.find possibleKeys

  extractKey: (str) ->
    try
      s11.note.extract(str).name
    catch err
      null

  displayKey: ->
    @props.displaySettings.displayKey or @key()

  formatChord: (chord) ->
    if chord
      transpose(@key(), @displayKey(), chord).replace(/'/g, '')

  formatChordWithAlts: (chord) ->
    if @props.parsedInput.alts[chord]? and @state.chordReplacements[chord]?
      chord = @props.parsedInput.alts[chord][@state.chordReplacements[chord]]
    @formatChord chord

  lastChord: ->
    try
      chords = _.flatten _.pluck @props.parsedInput.content, 'lines'
      _.last(chords).chord
    catch err
      ''

  resetKey: ->
    @setDisplayKey null

  switchState: ->
    _.pick @props.displaySettings, 'showChords', 'showLyrics', 'showFade', 'showSections', 'showAlternates', 'showUkulele'

  handleInput: (e) ->
    @props.handleInput e.target.value

  handleEditClick: ->
    @setState isEditing: not @state.isEditing

  toggleState: (key) ->
    @setState "#{key}": not @state[key]

  switches: ->
    _.map @switchState(), (value, key) =>
      label: S(key).chompLeft('show').s
      key: key
      active: value
      handleClick: => @props.toggleDisplaySwitch key

  selectAlt: (index) ->
    chordReplacements = @state.chordReplacements
    chordReplacements[@state.altsModalChord] = index
    @setState chordReplacements: chordReplacements, showChordAltModal: false

  setDisplayKey: (key) ->
    # If a song is set to its original key, treat that as a "reset" to null
    # Thus, if the song's key changes the display key will change as well
    @props.setDisplayKey if key is @extractKey @props.parsedInput.meta.KEY then null else key
    @setState showTransposeModal: false

  showChordAltModal: (chord) ->
    @setState showChordAltModal: true, altsModalChord: chord

  render: ->
    <Grid>
      <Row>
        <Col md={if @state.isEditing then 6 else 12}>
          {<EditButton isEditing={@state.isEditing} handleClick={@handleEditClick} /> unless @props.readOnly}
          {<DeleteButton handleClick={@props.deleteSong} /> unless @props.readOnly}
          {<ShareButton songId={@props.shareableSongId} /> unless @props.readOnly}
          <DisplaySettings switches={@switches()} adjustFontSize={@props.adjustFontSize} />
          <MarkatoOutput song={@props.parsedInput}
                         switches={@switchState()}
                         displayKey={@displayKey()}
                         showChordAltModal={@showChordAltModal}
                         chordReplacements={@state.chordReplacements}
                         formatChordWithAlts={@formatChordWithAlts}
                         playback={not @state.isEditing}
                         play={@state.play}
                         showTransposeModal={=> @toggleState 'showTransposeModal'}
                         setDisplayKey={@setDisplayKey}
                         fontSize={@props.displaySettings.fontSize} />
        </Col>
        {<Col md=6>
          <MarkatoInput input={@props.input}
                        handleInput={@handleInput} />
        </Col> if @state.isEditing}
      </Row>
      <ChordAltModal show={@state.showChordAltModal}
                     onHide={=> @toggleState 'showChordAltModal'}
                     chord={@state.altsModalChord}
                     alts={@props.parsedInput.alts[@state.altsModalChord]}
                     selected={@state.chordReplacements[@state.altsModalChord]}
                     selectAlt={@selectAlt}
                     formatChord={@formatChord} />
      <TransposeModal show={@state.showTransposeModal}
                      onHide={=> @toggleState 'showTransposeModal'}
                      displayKey={@displayKey()}
                      originalKey={@key()}
                      setDisplayKey={@setDisplayKey}
                      reset={@resetKey} />
    </Grid>
