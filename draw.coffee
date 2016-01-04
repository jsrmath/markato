canvas

window.draw = (location, song, state) ->
	canvas = $(location)
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
	

	chord = if not token.chord? then ' ' else token.chord
	chord = chord.replace('#', '&#x266F;')
	chord = chord.replace('b', '&#x266D;')
	string = if token.string=='' then ' ' else token.string.trim()

	pString = 'phrase'
	pString += if token.wordExtension then ' join' else ''

	result = ''
	result += "<p class=\"#{pString}\">"
	if state.showChords
		chString = 'chord'
		if state.smartMode
			chString += if token.exception then '' else ' mute'
		if state.showAlts
			chString += if token.alts.length>0 then ' alts' else ''
		result += "<span class=\"#{chString}\">#{chord}</span><br/>"
	result += "<span class='string'>#{string}</span>"
	result += "</p>"

	if token.alts.length>0 and token.exception and state.showAlts
		result += "<span class='sidebar alts'>#{token.chord} → ("
		result += token.alts.join(', ')
		result += ")</span><br/>"
	
	result

	
