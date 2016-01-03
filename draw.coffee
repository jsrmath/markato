canvas

window.draw = (location, song, state) ->
	canvas = $(location)
	cstring = ''
	cstring += "<div class='panel panel-info'><div class='panel-heading'>#{song.meta.TITLE}<br/><small>#{song.meta.ARTIST}</small></div><div class='panel-body'>"
	(
		if state.showSections
			cstring += "<div class='section'>#{lyric.section}</div><br/>"
		(
			(
				cstring += printToken(token, state)
			) for token in line
			cstring += "<br/>"
		) for line in lyric.lines
		cstring += "<br/>"
	) for lyric in song.lyrics
	cstring += "</dl>"
	cstring += "</div></div>"
	canvas.html cstring
	null

printToken = (token, state) ->

	chord = if not token.chord? then ' ' else token.chord
	string = if token.string=='' then ' ' else token.string.trim()

	pString = 'phrase'
	pString += if token.wordExtension then ' join' else ''

	result = ''
	result += "<p class=\"#{pString}\">"
	if state.showChords
		chString = 'chord'
		if state.smartMode
			chString += if token.exception then '' else ' mute'
		result += "<span class=\"#{chString}\">#{chord}</span><br/>"
	result += "<span class='string'>#{string}</span>"
	result += "</p>"
	
	result

	
