location = '#canvas'

state =
	showChords: true
	showLyrics: true
	showRepeats: false
	showAlts: true
	showSections: true
	smartMode: true
	requestedKey: null

replacements = null

initAlts = (obj) ->
	replacements = {}
	( replacements[chord] = null ) for chord in _.keys obj
	replacements

#REDRAW function - calls upon draw() from /draw.coffee
refresh = () ->
	file = parser.parseString $('#input').val()

	replacements = initAlts file.alts if _.isNull replacements
	state.replacements = replacements

	draw location, file, state
	
	#SWAP IN alts ON CLICK
	$('.alts').click ->
		chord = _.unescape $(this).attr('data-chord')
		$('#alternatesModal .modal-body').html generateAltsModal file.alts, chord

		if _.isNull state.replacements[chord]
			$('#resetChord').addClass('btn-info')
		else
			$("#alternatesModal .modal-body [data-index=#{state.replacements[chord]}]").addClass('btn-info')


		$('#alternatesModal').modal('show')
	
		$('#alternatesModal button').click ->
			chord = $(this).attr('data-chord')
			index = $(this).attr('data-index')
			replacements[chord] = if index? then index else null
			state.replacements = replacements
			$('#alternatesModal').modal('hide')
			refresh()

$ ->
	#
	# EXAMPLE is imported from /example.coffee
	$('#input').val(window.example)
	
	#
	# INITIAL draw
	refresh()

	#
	# CONSTANT BEHAVIORAL ASSIGNMENTS
	$('#input').keyup refresh

	#
	# TRANSPOSE
	$('#transposeUp').click ->
		state.requestedKey = createNote( $('#currentKey').html() ).sharp().clean().name
		refresh()

	$('#transposeDown').click ->
		state.requestedKey = createNote( $('#currentKey').html() ).flat().clean().name
		refresh()
	
	$('#transposeReset').click ->
		state.requestedKey = null
		$('#transposeModal').modal('hide')
		refresh()

	$('#transposeToolbar button').click ->
		clickedChord = $(this).attr('data-transposeChord')
		state.requestedKey = clickedChord
		$('#transposeModal').modal('hide')
		refresh()

	#
	# SWITCH BEHAVIOR
	$("[name='toggle-chords']").on 'switchChange.bootstrapSwitch', (event, bool)->
		state.showChords = if bool then true else false
		refresh()

	$("[name='toggle-lyrics']").on 'switchChange.bootstrapSwitch', (event, bool)->
		state.showLyrics = if bool then true else false
		refresh()
	
	$("[name='toggle-muted']").on 'switchChange.bootstrapSwitch', (event, bool)->
		state.smartMode = if bool then true else false
		refresh()
	
	$("[name='toggle-section']").on 'switchChange.bootstrapSwitch', (event, bool)->
		state.showSections = if bool then true else false
		refresh()

	$("[name='toggle-alts']").on 'switchChange.bootstrapSwitch', (event, bool)->
		state.showAlts = if bool then true else false
		refresh()

	$("[name='toggle-edit']").on 'switchChange.bootstrapSwitch', (event, bool)->
		if bool then $('#input').parent().show() else $('#input').parent().hide()
		if bool then $('#output').addClass('col-sm-6') else $('#output').removeClass('col-sm-6')
		refresh()
	
	#
	# DONE ONCE AT STARTUP
	$("input.bs").bootstrapSwitch()


generateAltsModal = (alts, chord) ->
	printChord = chord.replace(/'/g,'')
	fstring = ''
	fstring += "    <button type='button' class='btn btn-lg btn-link' disabled='disabled'>Replace</button>"
	fstring += "    <button type='button' class='btn btn-lg btn-default' id='resetChord' data-chord='#{_.escape chord}'>#{printChord}</button>"
	fstring += "    <button type='button' class='btn btn-lg btn-link' disabled='disabled'>with</button>"
	(
		fstring += "  <button type='button' class='btn btn-lg btn-default' data-chord='#{_.escape chord}' data-index='#{index}'>#{rep}</button>"
	) for rep, index in alts[chord]
	#fstring += "<br/><br/><hr/>"
	#fstring += "    <button type='button' class='btn btn-md btn-link'>Reset to</button>"
	#fstring += "    <button type='button' class='btn btn-md btn-default'>#{chord}</button>"
	return fstring







