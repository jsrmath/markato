_ = require 'underscore'
S = require 'string'
s11 = require 'sharp11'
React = require 'react'
ReactDOM = require 'react-dom'
classNames = require 'classnames'

module.exports = React.createClass
  title: ->
    @props.song.meta.TITLE or 'Untitled'

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

    classes = classNames ['chord',
      mute: @props.switches.showFade and not token.exception
      alts: hasAlts
    ]

    if chord and @props.switches.showChords
      <div className={classes} onClick={@props.showChordAltModal chord if hasAlts}>
        {@props.formatChord displayChord}
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
      <h2>{@title()} <small>in {@props.displayKey}</small></h2>
      {@byline()}
      {@content()}
    </div>