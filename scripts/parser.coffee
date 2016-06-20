# parser.coffee - Julian Rosenblum
# Parses Markato files into Markato object

_ = require 'underscore'
S = require 'string'

isChordLine = (line) -> S(line).startsWith ':'

parseFooterStartLine = (state, line) ->
  state.current.footer = true
  state

parseMetaLine = (state, line) ->
  prefix = line.split(' ')[0]
  metaName = prefix.slice 2 # Remove ##
  metaValue = S(line).chompLeft(prefix).trim().s

  state.meta[metaName] = metaValue
  state

parseFooterLine = (state, line) ->
  parts = S(line).strip(' ').split '=>'

  if parts.length is 2
    chord = parts[0]
    alts = parts[1].split ','
    state.alts[chord] = alts

  state

addSection = (state, sectionName) ->
  # It's a new section if we don't already have it on the list
  firstTime = not _.contains state.sections, sectionName

  state.sections.push sectionName
  content =
    section: sectionName
    firstTime: firstTime
    lines: []

  state.content.push content
  
  if firstTime then state.chords[sectionName] = []

  state.current.lastLine = null # We're in a new section, so forget last lyric/chord line
  state

parseSectionLine = (state, line) ->
  addSection state, S(line.slice 1).trim().s

parseLyricChordLine = (state, line) ->
  lastLine = state.current.lastLine

  # If we're not in a section, create one called untitled
  if not state.sections.length
    state = addSection state, "UNTITLED"

  # If we have a chord line
  if isChordLine line
    _.last(state.content).lines.push
      chords: S(line.slice 1).trim().s.split ' '
      lyrics: ''

  # If we have a lyric line
  else
    # If last line is a chord line, add lyrics to it
    if lastLine and not lastLine.lyrics
      lastLine.lyrics = line

    # Otherwise, we have a solitary line of lyrics
    else
      _.last(state.content).lines.push
        chords: []
        lyrics: line

  state.current.lastLine = _.last(_.last(state.content).lines)
  state

# Given a parse state, parses a line of Markato and returns updated state
parseLine = (state, line) ->
  # Remove extraneous whitespace
  line = S(line).trim().collapseWhitespace().s

  if not line then return state

  if S(line).startsWith '###' then return parseFooterStartLine state, line

  if S(line).startsWith '##' then return parseMetaLine state, line

  if S(line).startsWith '#' then return parseSectionLine state, line

  if state.current.footer then return parseFooterLine state, line

  return parseLyricChordLine state, line

interpretLyricChordLine = (state, section, lineObj, lineNum) ->
  sectionName = section.section
  {lyrics, chords} = lineObj
  phrases = []

  addPhrase = (obj) ->
    phrases.push _.defaults obj,
      lyric: ''
      chord: ''
      exception: false
      wordExtension: false

  # If this is a new section, add the chords to that section
  if section.firstTime
    state.chords[sectionName].push chords

  # Get the chords stored for the section
  sectionChords = state.chords[sectionName][lineNum]

  caretSplit = lyrics.split '^' # Used to figure out phrases
  chordIndex = 0 # Index in list of chords as we assemble phrases
  exceptionIndices = [] # Chord indices that are exceptions in this section

  # If there is no above line of chords, use the section chords
  if not chords.length
    chords = sectionChords

  # Otherwise, substitute * from chords where necessary
  else
    chords = _.map chords, (chord, index) ->
      # For *, get the chord at the same index from the chord list
      if chord is '*'
        sectionChords[index]
      else
        exceptionIndices.push index
        chord

  # If there are no lyrics, just add a line of chords
  if not lyrics
    _.each chords, (chord, index) ->
      addPhrase
        chord: chord
        exception: _.contains exceptionIndices, index

  # Otherwise, add lyrics based on carets
  else
    _.each caretSplit, (phrase, index) ->
      # Special case first phrase
      if index is 0
        if phrase
          addPhrase lyric: caretSplit[0]
        return

      lastPhrase = caretSplit[index - 1]

      # Get next chord
      chord = chords[chordIndex]

      # 'foo ^ bar' case, we insert the chord with a blank lyric
      if phrase? and phrase[0] is ' '
        addPhrase
          chord: chord
          exception: _.contains exceptionIndices, chordIndex

        addPhrase lyric: S(phrase).trim().s,
      else
        addPhrase
          lyric: S(phrase).trim().s
          chord: chord
          exception: _.contains exceptionIndices, chordIndex

      # Check for foo^bar case (doesn't start with space and last phrase doesn't end with one)
      if phrase and lastPhrase and phrase[0] isnt ' ' and S(lastPhrase).right(1).s isnt ' '
        _.last(phrases).wordExtension = true

      chordIndex += 1

  phrases

# Given a parse state, interpret the lyric/chord lines
interpretLyricSection = (state, section) ->
  section.lines = _.map section.lines, _.partial interpretLyricChordLine, state, section

  # If this is an empty section, retrieve the lyrics/chords from the first instance of that section
  if not section.lines.length
    section.lines = _.findWhere(state.content, section: section.section).lines.concat()

    # None of the phrases are exceptions since we're copying them
    # We also have to clone the phrase objects so that we don't overwrite the other versions
    section.lines = _.map section.lines, (line) ->
      _.map line, (phrase) -> _.extend(_.clone(phrase), exception: false)

  section

# Given a finished parse state, return a markato object
markatoObjectFromState = (state) -> 
  state = _.omit state, 'current'

  # Add ids for sections, lines, and phrases
  sectionId = lineId = phraseId = lyricId = chordId = 0
  _.each state.content, (section) ->
    section.sectionId = sectionId++
    _.each section.lines, (line) ->
      line.lineId = lineId++
      _.each line, (phrase) ->
        phrase.phraseId = phraseId++
        phrase.chordId = chordId++ if phrase.chord
        phrase.lyricId = lyricId++ if phrase.lyric

  state.count = 
    sections: sectionId
    lines: lineId
    phrases: phraseId
    lyrics: lyricId
    chords: chordId

  state


module.exports =
  # Parses a string of Markato and returns a Markato object
  parseString: (str) ->
    lines = S(str).lines()

    parseState =
      current:
        footer: false # Are we in the footer?
        lastLine: null # Previous lyric/chord line in this section
      meta: {}
      alts: {}
      sections: []
      chords: {}
      content: []

    # Run parser
    parseState = _.reduce lines, parseLine, parseState

    # Interpret lyric/chord lines
    parseState.content = _.map parseState.content, _.partial interpretLyricSection, parseState

    markatoObjectFromState parseState