_ = require 'underscore'
S = require 'string'
s11 = require 'sharp11'
React = require 'react'
ReactDOM = require 'react-dom'
classNames = require 'classnames'

module.exports = React.createClass
  title: ->
    @props.song.meta.TITLE or 'Untitled'

  key: ->
    validKeys = ['C','C#','Db','D','D#','Eb','E','F','F#','Gb','G','G#','Ab','A','A#','Bb','B']
    possibleKeys = [
      @props.song.meta.KEY,
      @lastInferredChord(),
      @lastDefinedChord(),
      'C'
    ]
    #return first from possibleKeys where key is in validKeys
    _.find possibleKeys, (key) -> key in validKeys

  displayKey: ->
    @props.displayKey or @key()

  lastInferredChord: ->
    try 
      chord = _.last(_.last(_.last(@props.song.lyrics).lines)).chord
      s11.note.create(chord).clean().name
    catch e
      ''

  lastDefinedChord: ->
    try
      chord = _.last _.last @props.song.chords[_.last @props.song.sections]
      s11.note.create(chord).clean().name
    catch e
      ''

  byline: ->
    <h4>{@props.song.meta.ARTIST or "Unknown"} <i>{@props.song.meta.ALBUM}</i></h4>

  renderSectionHeader: (section) ->
    if @props.switches.showSections
      <div className="section-header">{section.section}<hr /></div>

  renderLine: (line) ->
    <div>{_.map line, @renderToken}</div>

  renderLyric: (token) ->
    lyric = S(token.string).trim().s

    if (lyric or @props.switches.showChords) and @props.switches.showLyrics
      <div className="lyric">{lyric or ' '}</div>

  renderChord: (token) ->
    hasAlts = @props.song.alts[token.chord]? and token.exception and @props.switches.showAlternates

    chord = displayChord = token.chord
    
    displayChord = @props.song.alts[chord][@props.chordReplacements[chord]] if @props.chordReplacements[chord]?
    displayChord = displayChord.replace /'/g, ''

    classes = classNames ['chord',
      mute: @props.switches.showFade and not token.exception
      alts: hasAlts
    ]

    if chord and @props.switches.showChords
      <div className={classes} onClick={@props.showChordAltModal chord if hasAlts}>
        {displayChord}
      </div>

  renderToken: (token) ->
    lyric = @renderLyric token
    chord = @renderChord token

    return unless lyric or chord

    classes = classNames ['phrase',
      join: token.wordExtension
    ]

    <div className={classes}>{chord}{lyric}</div>

  content: ->
    _.map @props.song.lyrics, (section, i) =>
      <div>
        {@renderSectionHeader(section)}
        <div className="section">{_.map section.lines, @renderLine}</div>
      </div>

  render: ->
    <div>
      <h2>{@title()} <small>in {@key()}</small></h2>
      {@byline()}
      {@content()}
    </div>