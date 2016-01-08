# parser.coffee - Julian Rosenblum
# Parses Markato files into Markato object
# Dependencies: underscore.js, string.js

window.parser = (->
  isChordLine = (line) -> S(line).startsWith ':'

  preParseFooterStartLine = (state, line) ->
    state.current.footer = true
    state
  
  preParseMetaLine = (state, line) ->
    prefix = line.split(' ')[0]
    metaName = prefix.slice 2 # Remove ##
    metaValue = S(line).chompLeft(prefix).trim().s

    state.meta[metaName] = metaValue
    state

  preParseFooterLine = (state, line) ->
    parts = S(line).strip(' ').split('=>')

    if parts.length is 2
      chord = parts[0]
      alts = parts[1].split ','
      state.alts[chord] = alts

    state

  preParseTextLine = (state, line) ->
    lastLine = _.last state.lines if state.lines.length

    # If we have a section header
    if S(line).startsWith '#'
      state.lines.push
        type: 'section'
        name: S(line.slice 1).trim().s

    # If we have a chord line
    else if isChordLine line
      state.lines.push
        type: 'lyricChord'
        chords: S(line.slice 1).trim().s.split ' '
        lyrics: ''

    # If we have a lyric line
    else
      # If last line is a chord line, add lyrics to it
      if lastLine and lastLine.type is 'lyricChord' and not lastLine.lyrics
        lastLine.lyrics = line

      # Otherwise, we have a solitary line of lyrics
      else
        state.lines.push
          type: 'lyricChord'
          chords: []
          lyrics: line

    state

  # Given a preparse state, preparses a line of Markato and returns updated state
  preParseLine = (state, line) ->
    # Remove extraneous whitespace
    line = S(line).trim().collapseWhitespace().s

    if not line then return state

    if S(line).startsWith '###' then return preParseFooterStartLine state, line

    if S(line).startsWith '##' then return preParseMetaLine state, line

    if state.current.footer then return preParseFooterLine state, line

    return preParseTextLine state, line

  addSection = (state, sectionName) ->
    state.current.sectionName = sectionName

    # It's a new section if we don't already have it on the list
    state.current.newSection = !_.contains state.sections, sectionName

    state.current.line = 0

    state.sections.push sectionName
    state.lyrics.push
      section: sectionName
      firstTime: state.current.newSection
      lines: []
    
    if state.current.newSection then state.chords[sectionName] = []

    state

  addLyricChord = (state, lyrics, chords) ->
    sectionName = state.current.sectionName
    caratSplit = lyrics.split '^' # Used to figure out phrases
    chordIndex = 0 # Index in list of chords as we assemble phrases
    phrases = []
    exceptionIndices = [] # Chord indices that are exceptions in this section

    addPhrase = (obj) ->
      phrases.push _.defaults obj,
        string: ''
        chord: ''
        exception: false
        wordExtension: false

    # If we're not in a section, create one called untitled
    if sectionName is null
      sectionName = 'UNTITLED'
      state = addSection state, sectionName

    # If this is a new section, add the chords to that section
    if state.current.newSection
      state.chords[sectionName].push chords

    # Get the chords stored for the section
    sectionChords = state.chords[sectionName][state.current.line]

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

    # Otherwise, add lyrics based on carats
    else
      _.each caratSplit, (phrase, index) ->
        # Special case first phrase
        if index is 0
          if phrase
            addPhrase string: caratSplit[0]
          return

        lastPhrase = caratSplit[index - 1]

        # Get next chord
        chord = chords[chordIndex]

        # 'foo ^ bar' case, we insert the chord with a blank lyric
        if phrase? and phrase[0] is ' '
          addPhrase
            chord: chord
            exception: _.contains exceptionIndices, chordIndex

          addPhrase string: S(phrase).trim().s,
        else
          addPhrase
            string: S(phrase).trim().s
            chord: chord
            exception: _.contains exceptionIndices, chordIndex

        # Check for foo^bar case (doesn't start with space and last phrase doesn't end with one)
        if phrase and lastPhrase and phrase[0] isnt ' ' and S(lastPhrase).right(1).s isnt ' '
          _.last(phrases).wordExtension = true

        chordIndex += 1
    
    # Add new line to current lyric section
    _.last(state.lyrics).lines.push phrases

    state.current.line += 1
    state

  # Given a parse state, parses a line of Markato and returns updated state
  parseLine = (state, line) ->
    if line.type is 'section' then return addSection state, line.name

    if line.type is 'lyricChord' then return addLyricChord state, line.lyrics, line.chords

    state # Should not ever reach this

  # Given a finished parse state, return a markato object
  markatoObjectFromState = (state) -> _.omit state, 'current'

  # Parses a string of Markato and returns a Markato object
  return {
    parseString: (str) ->
      lines = S(str).lines()

      preParseState =
        current:
          footer: false # Are we in the footer?
        meta: {}
        alts: {}
        lines: []

      parseState =
        current:
          sectionName: null # Current section we're in
          newSection: true # Is this a section being newly defined?
          line: 0 # What line of the section are we in (incremented on parseLyric)
        sections: []
        chords: {}
        lyrics: []

      # Run preparser
      preParseState = _.reduce lines, preParseLine, preParseState

      # Extract relevant information from preParseState
      parseState.meta = preParseState.meta
      parseState.alts = preParseState.alts

      parseState = _.reduce preParseState.lines, parseLine, parseState
      markatoObjectFromState parseState
  }
)()