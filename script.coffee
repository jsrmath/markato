location = '#canvas'
file = ''

state =
	showChords: true
	showLyrics: true
	showRepeats: false
	showAlts: true
	showSections: true
	smartMode: true
	requestedKey: null

#REDRAW function - calls upon draw() from /draw.coffee
refresh = () ->
	file = parser.parseString $('#input').val()
	console.log file
	draw location, file, state
	
	#SWAP IN ALTERNATIVES ON CLICK
	$('.alts a').click ->
		id = $(this).parent().attr('data-id-from')
		$("span[data-id-to='#{id}']").html($(this).html())

$ ->

	# EXAMPLE is imported from /example.coffee
	$('#input').val(window.example)

	# INITIAL draw
	refresh()

	#
	# CONSTANT BEHAVIORAL ASSIGNMENTS
	#
	
	$('#input').keyup refresh

	#
	# TRANSPOSE
	#

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
	#

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
	#
	
	$("input.bs").bootstrapSwitch()

