canvas
alts = {}

window.draw = (location, song, state) ->
	canvas = $(location)
	alts = song.alts
	console.log alts

	cstring = ''
	cstring += "<div class='panel panel-info'><div class='panel-heading'>#{song.meta.TITLE}<br/><small>#{song.meta.ARTIST} - #{song.meta.ALBUM}</small></div><div class='panel-body'>"
	(
		if state.showSections
			cstring += "<div class='section-header'>#{section.section}</div><hr/>"
		cstring += "<div class='section'>"
		(
			(
				cstring += printToken(token, state)
			) for token in line
			cstring += "<br/>"
		) for line in section.lines
		cstring += "</div><br/>"
	) for section in song.lyrics
	cstring += "</dl>"
	cstring += "</div></div>"
	canvas.html cstring
	null

printToken = (token, state) ->
	hasAlts = false
	#console.log token
	if token.chord.endsWith('\'')
		hasAlts = true

	chord = if not token.chord? then ' ' else token.chord
	chord = chord.replace('#', '&#x266F;')
	chord = chord.replace('b', '&#x266D;')
	chord = chord.replace(/'/g,'')
	allowable = token.chord.replace(/'/g,'')
	num = token.chord.length - allowable.length
	identifier = allowable + num
	string = if token.string=='' then ' ' else token.string.trim()

	pString = 'phrase'
	pString += if token.wordExtension then ' join' else ''

	result = ''
	result += "<p class=\"#{pString}\">"
	if state.showChords
		chString = 'chord'
		if state.smartMode
			chString += if token.exception then '' else ' mute'
		if state.showAlts and token.exception and alts[token.chord]?
			chString += if hasAlts then ' alts' else ''
		result += "<span class=\"#{chString}\" data-id-to=\"#{identifier}\">#{chord}</span><br/>"
	result += "<span class='string'>#{string}</span>"
	result += "</p>"

	if hasAlts and token.exception and state.showAlts and alts[token.chord]?
		result += "<span class='sidebar alts' data-id-from=\"#{identifier}\">"
		result += "<a>#{chord}</a> → <a>"
		result += alts[token.chord].join('</a>, <a>')
		result += "</a></span><br/>"
	
	result

	
