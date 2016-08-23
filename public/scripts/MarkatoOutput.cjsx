_ = require 'underscore'
s11 = require 'sharp11'
React = require 'react'
classNames = require 'classnames'
MarkatoContent = require './MarkatoContent'
TransposeToolbar = require './TransposeToolbar'

module.exports = React.createClass
  getInitialState: ->
    currentChordId: 0

  componentDidMount: ->
    document.body.onkeydown = @handleKeyPress

  title: ->
    @props.song.meta.TITLE or 'Untitled'

  byline: ->
    <h4>{@props.song.meta.ARTIST or "Unknown"} <i>{@props.song.meta.ALBUM}</i></h4>

  selectChordId: (chordId) ->
    @setState currentChordId: chordId

  nextChord: ->
    chord = @state.currentChordId + 1
    if chord is @props.song.count.chords
      chord = 0
    @setState currentChordId: chord

  previousChord: ->
    chord = @state.currentChordId - 1
    if chord is -1
      chord = @props.song.count.chords - 1
    @setState currentChordId: chord

  playChord: ->
    chords = _.flatten _.pluck @props.song.content, 'lines'
    chord = _.findWhere(chords, chordId: @state.currentChordId).chord
    @props.play s11.chord.create @props.formatChordWithAlts chord

  handleKeyPress: (e) ->
    if @props.playback
      e.preventDefault()
      if e.keyCode is 32 # Space
        @playChord()
      if e.keyCode is 37 # Left
        @previousChord()
      if e.keyCode is 39 # Right
        @nextChord()

  render: ->
    <div className={"markato-output font-#{@props.fontSize}"}>
      <h2>
        {@title()}
        <TransposeToolbar displayKey={@props.displayKey}
                          showTransposeModal={@props.showTransposeModal}
                          setDisplayKey={@props.setDisplayKey} />
      </h2>
      {@byline()}
      <MarkatoContent song={@props.song}
                      playback={@props.playback}
                      currentChordId={@state.currentChordId}
                      switches={@props.switches}
                      handleChordClick={@handleChordClick}
                      formatChordWithAlts={@props.formatChordWithAlts}
                      selectChordId={@selectChordId}
                      showChordAltModal={@props.showChordAltModal} />
    </div>