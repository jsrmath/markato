location = '#canvas'
file = ''

example = '''
##TITLE  I Wanna Hold Your Hand
##ARTIST The Beatles
##ALBUM A Hard Day's Night

#INTRO
: G D Em Bm

#VERSE
:       G'             D          Em               E7    Bm'
Oh yeah ^I'll tell you ^something ^ I think you'll ^under^stand
:    G           D           Em                     B7
When ^I say that ^something, ^ I want to hold your h^and!

#CHORUS
:C         D          G  Em  
^ I wanna ^hold your ^ha^nd!
:C         D          G      
^ I wanna ^hold your ^hand!

#VERSE
Oh ^please say to ^me, ^ you'll let me ^be your ^man
:  *              G    *                          *
Oh ^please say to ^me, ^ you'll let me hold your h^and

#CHORUS
^Now let me ^hold your ^ha^nd
^ I wanna ^hold your ^hand

#BRIDGE
:Dm           G                 C        Am        
^ And when I ^touch you I feel ^happy in^side
:Bm''          G                C              D   
^ It's such a ^feeling that my ^love, I can't ^hide
:C         D                                       
^ I can't ^hide
:C         D                                       
^ I can't ^hide

#VERSE
Yeah-ah ^you, got that ^something ^ I think you'll under^stand.
When ^I feel that ^something, ^ I wanna hold your ^hand.

#CHORUS
^ I wanna ^hold your ^ha^and!
^ I wanna ^hold your ^hand!

###
G' => Gsus4
Bm'  => Bm7#11, Bmaj7
Bm'' => Dm
'''

$ ->
	state =
		showChords: true
		showRepeats: false
		showAlts: true
		showSections: true
		smartMode: true
		transpose: 0

	refresh = () ->
		file = parser.parseString $('#input').val()
		console.log file
		draw location, file, state
		
		#SWAP IN ALTERNATIVES ON CLICK
		$('.alts a').click ->
			id = $(this).parent().attr('data-id-from')
			$("span[data-id-to='#{id}']").html($(this).html())

	$('#input').val(example)

	refresh()

	#CONSTANT BEHAVIORAL ASSIGNMENTS
	
	$('#input').keyup refresh

	$('#transpose button').click ->
		id = $(this).attr('id')
		switch id
			when "transposeUp"
				state.transpose++
			when "transposeDown"
				state.transpose--
			else
				state.transpose = 0
		console.log state.transpose
		refresh()

	$("[name='toggle-chords']").on 'switchChange.bootstrapSwitch', (event, bool)->
		state.showChords = if bool then true else false
		if not bool #if toggling 'no', turn off related things automatically
			$("input[name='toggle-muted']").bootstrapSwitch 'state', false
			$("input[name='toggle-alts']").bootstrapSwitch 'state', false
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

	#DONE ONCE AT STARTUP
	
	$("input.bs").bootstrapSwitch()

	#$("input[name='toggle-chords']").bootstrapSwitch 'state', true
	#$("input[name='toggle-muted']").bootstrapSwitch 'state', true
	#$("input[name='toggle-section']").bootstrapSwitch 'state', true
	#$("input[name='toggle-alts']").bootstrapSwitch 'state', true

	#$("input[name='toggle-edit']").bootstrapSwitch 'state', true
	#$("input[name='toggle-edit']").bootstrapSwitch 'state', false

