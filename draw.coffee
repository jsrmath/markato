#GLOBAL draw function -- takes a canvas location, a song data file, and a current state
window.draw = (location, song, state) ->
	state.originalKey = determineKey song
	state.drawKey = if state.requestedKey? then state.requestedKey else state.originalKey
	state.alts = song.alts

	printKeysToDOM state
	$(location).html generateHTML song, state

	null

#PRINT KEYS TO DOM
printKeysToDOM = (state) ->
	$('#currentKey').html state.drawKey
	$('#originalKey').html state.originalKey
	$("#transposeToolbar button").removeClass('btn-info')
	$("[data-transposeChord=#{state.drawKey}]").addClass('btn-info')
	null

#generates the string to be printed in the DOM
generateHTML = (song, state) ->
	cstring = ''
	cstring += "<button type='button' class='btn #{if state.isEditing then 'btn-success' else 'btn-info btn-md'}' id='edit'> <span class='glyphicon #{if state.isEditing then 'glyphicon-check' else 'glyphicon-edit'}' aria-hidden='true'></span> #{if state.isEditing then 'Save' else 'Edit'} </button>"
	cstring += "<h2>#{title song} <small>in #{state.drawKey}</small></h2>"
	cstring += "<h4>#{byline song}</h4>"
	(
		if state.showSections
			cstring += "<div class='section-header'>#{section.section}</div>"
			cstring += "<hr/>"
		cstring += "<div class='section'>"
		(
			(
				cstring += generateToken(token, state)
			) for token in line
			cstring += "<br/>"
		) for line in section.lines
		cstring += "</div><br/>"
	) for section in song.lyrics
	cstring

#generates the HTML of a given phrase token
generateToken = (token, state) ->
	token.hasAlts = if state.alts[token.chord]? then true else false

	chord = if not token.chord? then ' ' else token.chord

	chord = state.alts[chord][state.replacements[chord]] if state.replacements[chord]? #replace if an alternative is toggled
	chord = chord.replace(/'/g,'')
	
	string = if token.string=='' then ' ' else token.string.trim()

	phrase_classes = ['phrase']
	phrase_classes.push('join') if token.wordExtension

	chord_classes = ['chord']
	chord_classes.push('mute') if state.smartMode and not token.exception
	chord_classes.push('alts') if token.hasAlts and token.exception and state.showAlts
	
	if state.drawKey != state.originalKey and chord != ''
		chord = transpose(state.originalKey, state.drawKey, chord)

	chord = chord.replace('#', '&#x266F;').replace('b', '&#x266D;')

	#edge case to avoid - printing empty <p> on chordOnly mode
	if(not state.showLyrics and chord=='') then return ''
	#edge case to avoid - printing empty paragraphs on lyricOnly mode
	if (string == ' ' and not state.showChords) then return ''

	result = ''
	result += "<p class='#{phrase_classes.join(' ')}'>"
	if state.showChords
		result += "<span class='#{chord_classes.join(' ')}' data-chord='#{_.escape token.chord}'>#{chord}</span><br/>"
	if string? and state.showLyrics
		result += "<span class='string'>#{string}</span>"
	result += "</p>"

	result

#much less broken
determineKey = (song) ->
	validKeys = [ 'C','C#','Db','D','D#','Eb','E','F','F#','Gb','G','G#','Ab','A','A#','Bb','B' ]
	key = song.meta.KEY if song.meta.KEY?
	if key not in validKeys
		key = createNote( lastInferredChord song ).clean().name
	if key not in validKeys
		key = createNote( lastDefinedChord song ).clean().name
	if key not in validKeys
		key = 'C'
	key

#this is some tricky JSON-specific logic and it's ugly and i hate it
lastInferredChord = (song) ->
	#lastLines = _.last(song.lyrics).lines
	#lastLine = _.last(lastLines)
	#_.last(lastLine).chord
	_.last( _.last( _.last( song.lyrics).lines ) ).chord

lastDefinedChord = (song) ->
	#lastSectionTitle = _.last(song.sections)
	#lastSection = song.chords[lastSectionTitle]
	#lastLine = _.last(lastSection)
	#_.last(lastLine)
	_.last _.last song.chords[_.last song.sections]

#returns a title string
title = (song) ->
	if song.meta.TITLE? then song.meta.TITLE else '?'

#returns a byline string
byline = (song) ->
	"#{song.meta.ARTIST || "?"} <i> #{song.meta.ALBUM || "?"}</i>"












