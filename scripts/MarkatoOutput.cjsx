_ = require 'underscore'
S = require 'string'
s11 = require 'sharp11'
React = require 'react'
ReactDOM = require 'react-dom'
classNames = require 'classnames'

module.exports = React.createClass
  title: ->
    @props.song.meta.TITLE || 'Untitled'

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

  chordReplacements: ->
    {}

  displayKey: ->
    @props.displayKey || @key()

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
    <h4>{@props.song.meta.ARTIST || "Unknown"} <i>{@props.song.meta.ALBUM}</i></h4>

  renderSectionHeader: (section) ->
    <div className="section-header">{section.section}<hr /></div> if @props.showSections

  renderLine: (line) ->
    <div>{_.map line, @renderToken}</div>

  renderLyric: (token) ->
    lyric = S(token.string).trim().s

    if @props.showLyrics
      <span className="string">{lyric || ' '}</span>

  renderChord: (token) ->
    hasAlts = @props.song.alts[token.chord]?

    chord = token.chord
    chord = @props.song.alts[chord][@chordReplacements[chord]] if @chordReplacements[chord]?
    chord = chord.replace /'/g, ''
    if chord and @displayKey() is not @key()
      chord = transpose(@key(), @displayKey(), chord)

    classes = classNames ['chord',
      mute: @props.fade and not token.exception
      alts: hasAlts and token.exception and @props.showAlts
    ]

    if chord? and @props.showChords
      <div className={classes}>{chord}</div>

  renderToken: (token) ->
    lyric = @renderLyric token
    chord = @renderChord token

    return unless lyric? or chord?

    classes = classNames ['phrase',
      join: token.wordExtension
    ]

    <p className={classes}>{chord}{lyric}</p>

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