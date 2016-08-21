_ = require 'underscore'
S = require 'string'
React = require 'react'
classNames = require 'classnames'

module.exports = React.createClass
  switches: ->
    @props.switches or
      showChords: true
      showLyrics: true
      showFade: true
      showSections: true
      showAlternates: true

  renderSectionHeader: (section) ->
    if @switches().showSections
      <div className="section-header">{section.section}<hr /></div>

  renderLine: (line) ->
    <div key={line.lineId}>{_.map line, @renderPhrase}</div>

  renderLyric: (phrase) ->
    lyric = S(phrase.lyric).trim().s

    if (lyric or @switches().showChords) and @switches().showLyrics
      <div className="lyric">{lyric or ' '}</div>

  renderChord: (phrase) ->
    hasAlts = @props.song.alts[phrase.chord]? and phrase.exception and @switches().showAlternates
    chord = phrase.chord

    classes = classNames ['chord',
      'mute': @switches().showFade and not phrase.exception
      'clickable-color': hasAlts
      'clickable': @props.playback
      'playback-active': @props.playback and @props.currentChordId is phrase.chordId
    ]

    if chord and @switches().showChords
      <div className={classes} onClick={@props.handleChordClick phrase.chordId if @props.handleChordClick}>
        {if @props.formatChordWithAlts then @props.formatChordWithAlts chord else chord}
      </div>

  renderPhrase: (phrase) ->
    lyric = @renderLyric phrase
    chord = @renderChord phrase

    return unless lyric or chord

    classes = classNames ['phrase',
      join: phrase.wordExtension and lyric
    ]

    <div className={classes} key={phrase.phraseId}>{chord}{lyric}</div>

  renderContent: ->
    _.map @props.song.content, (section) =>
      <div key={section.sectionId}>
        {@renderSectionHeader(section)}
        <div className="section">{_.map section.lines, @renderLine}</div>
      </div>

  render: ->
    <div onClick={@props.onClick}>{@renderContent()}</div>