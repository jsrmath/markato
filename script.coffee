location = '#canvas'
$ ->
	state =
		showChords: true
		showRepeats: false
		smartMode: true
	draw(location, hold, state)
	$('#showChords').change ->
		idd = $('#showChords label.active').attr('id')
		state.showChords = if idd=='none' then false else true
		state.smartMode = if idd=='smart' then true else false
		draw(location, hold, state)
	$('#showSections').change ->
		idd = $('#showSections label.active').attr('id')
		state.showSections = if idd=='on' then true else false
		draw(location, hold, state)
	$('#showChords #smart').click()
	$('#showSections #on').click()
