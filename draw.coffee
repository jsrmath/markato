canvas
alts = {}

window.draw = (location, song, state) ->
	canvas = $(location)
	alts = song.alts
	key = determineKey song
	state.key = key
	printKey = if state.requestedKey? then state.requestedKey else state.key
	$('#key').html printKey
	$("#transposeToolbar button").removeClass('btn-info')
	$("[data-transposeChord=#{printKey}]").addClass('btn-info')

	cstring = ''
	cstring += "<h2>#{title song}</h2>"
	cstring += "<h4>#{byline song}</h4>"

	(
		if state.showSections
			cstring += "<div class='section-header'>#{section.section}</div>"
			cstring += "<hr/>"
		cstring += "<div class='section'>"
		(
			(
				cstring += printToken(token, state)
			) for token in line
			cstring += "<br/>"
		) for line in section.lines
		cstring += "</div><br/>"
	) for section in song.lyrics
	canvas.html cstring
	null

printToken = (token, state) ->
	hasAlts = if token.chord.endsWith('\'') then true else false

	chord = if not token.chord? then ' ' else token.chord
	chord = chord.replace(/'/g,'')
	
	string = if token.string=='' then ' ' else token.string.trim()

	phrase_classes = ['phrase']
	if token.wordExtension
		phrase_classes.push('join')

	chord_classes = ['chord']
	if state.showAlts and hasAlts and token.exception and alts[token.chord]?
		chord_classes.push('alts')
	if state.smartMode and not token.exception
		chord_classes.push('mute')

	allowable = token.chord.replace(/'/g,'') #prints without ' footnotes
	diff = token.chord.length - allowable.length #number of 's
	identifier = allowable + diff #unique identifier

	if state.requestedKey? and chord != ''
		chord = transpose(state.key, state.requestedKey, chord)

	chord = chord.replace('#', '&#x266F;')
	chord = chord.replace('b', '&#x266D;')

	result = ''
	result += "<p class=\"#{phrase_classes.join(' ')}\">"
	if state.showChords
		result += "<span class=\"#{chord_classes.join(' ')}\" data-id-to=\"#{identifier}\">#{chord}</span><br/>"
	result += "<span class='string'>#{string}</span>"
	result += "</p>"

	#print alternate sidebar if necessary
	#if hasAlts and token.exception and state.showAlts and alts[token.chord]?
	#	result += "<span class='sidebar alts' data-id-from=\"#{identifier}\">"
	#	result += "<a>#{chord}</a> → <a>"
	#	result += alts[token.chord].join('</a>, <a>')
	#	result += "</a></span><br/>"
	
	result

determineKey = (song) ->
	key = ''
	#check if predefined
	if song.meta.KEY?
		key = song.meta.KEY
	else #if not predefined
		#guess from the last inferred chord
		last_lines =song.lyrics[song.lyrics.length-1].lines
		last_line = last_lines[last_lines.length-1]
		last_phrase = last_line[last_line.length-1]
		key = last_phrase.chord
		if not key? #if nothing is inferred, check the last defined chord
			last_section_name = song.sections[song.sections.length-1]
			last_section = song.chords[last_section_name]
			last_line = last_section[last_section.length-1]
			last_chord = last_line[last_line.length-1]
			key = last_chord
	return key

title = (song) ->
	if song.meta.TITLE? then song.meta.TITLE else '?'

byline = (song) ->
	if song.meta.ARTIST? and song.meta.ALBUM?
		"#{song.meta.ARTIST} — #{song.meta.ALBUM}"
	else if song.meta.ARTIST?
		"#{song.meta.ARTIST} — ?"
	else if song.meta.ALBUM?
		"? — #{song.meta.ALBUM}"
	else
		"? — ?"
