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
		smartMode: true

	refresh = () ->
		file = parser.parseString $('#input').val()
		console.log file
		draw location, file, state

	$('#input').val(example)
	refresh()
	
	$('#input').keyup refresh

	$('#showChords').change ->
		idd = $('#showChords label.active').attr('id')
		state.showChords = if idd=='none' then false else true
		state.smartMode = if idd=='smart' then true else false
		draw(location, file, state)

	$('#showSections').change ->
		idd = $('#showSections label.active').attr('id')
		state.showSections = if idd=='on' then true else false
		draw(location, file, state)

	$('#showAlts').change ->
		idd = $('#showAlts label.active').attr('id')
		state.showAlts = if idd=='on' then true else false
		draw(location,file,state)

	$('#showChords #smart').click()
	$('#showSections #on').click()
	$('#showAlts #on').click()

