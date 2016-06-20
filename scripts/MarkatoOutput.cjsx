_ = require 'underscore'
S = require 'string'
s11 = require 'sharp11'
React = require 'react'
ReactDOM = require 'react-dom'
classNames = require 'classnames'

module.exports = React.createClass
  getInitialState: ->
    currentChordId: 0

  componentDidMount: ->
    document.body.onkeydown = @handleKeyPress

  title: ->
    @props.song.meta.TITLE or 'Untitled'

  byline: ->
    <h4>{@props.song.meta.ARTIST or "Unknown"} <i>{@props.song.meta.ALBUM}</i></h4>

  renderSectionHeader: (section) ->
    if @props.switches.showSections
      <div className="section-header">{section.section}<hr /></div>

  renderLine: (line) ->
    <div key={line.lineId}>{_.map line, @renderPhrase}</div>

  renderLyric: (phrase) ->
    lyric = S(phrase.lyric).trim().s

    if (lyric or @props.switches.showChords) and @props.switches.showLyrics
      <div className="lyric">{lyric or ' '}</div>

  renderChord: (phrase) ->
    hasAlts = @props.song.alts[phrase.chord]? and phrase.exception and @props.switches.showAlternates
    chord = phrase.chord

    classes = classNames ['chord',
      'mute': @props.switches.showFade and not phrase.exception
      'alts': hasAlts
      'clickable': @props.playback
      'playback-active': @props.playback and @state.currentChordId is phrase.chordId
    ]

    handleChordClick = =>
      @setState currentChordId: phrase.chordId if @props.playback
      @props.showChordAltModal chord if hasAlts

    if chord and @props.switches.showChords
      <div className={classes} onClick={handleChordClick}>
        {@props.formatChordWithAlts chord}
      </div>

  renderPhrase: (phrase) ->
    lyric = @renderLyric phrase
    chord = @renderChord phrase

    return unless lyric or chord

    classes = classNames ['phrase',
      join: phrase.wordExtension
    ]

    <div className={classes} key={phrase.phraseId}>{chord}{lyric}</div>

  content: ->
    _.map @props.song.content, (section) =>
      <div key={section.sectionId}>
        {@renderSectionHeader(section)}
        <div className="section">{_.map section.lines, @renderLine}</div>
      </div>

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
    <div>
      <h2>{@title()} <small>in {@props.displayKey}</small></h2>
      {@byline()}
      {@content()}
    </div>