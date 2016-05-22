draw = require './draw'
example = require './example'
parser = require './parser'
transpose = require './transpose'
audio = require './audio'
window.$ = window.jQuery = require 'jquery'
_ = require 'underscore'
S = require 'string'
s11 = require 'sharp11'

require 'bootstrap/dist/js/bootstrap'
require 'bootstrap-switch/dist/js/bootstrap-switch'

audio.init (play, stop) ->
  location = '#canvas'

  state =
    showChords: true
    showLyrics: true
    showRepeats: false
    showAlts: true
    showSections: true
    smartMode: true
    requestedKey: null
    isEditing: true
    showSettings: true
    playbackChordIndex: 0

  replacements = null

  initAlts = (obj) ->
    replacements = {}
    ( replacements[chord] = null ) for chord in _.keys obj
    replacements

  # Playback
  currentChord = -> $('.chord').eq(state.playbackChordIndex);
  currentChordData = -> currentChord().text()
  incrementChord = ->
    currentChord().removeClass('playback-active')

    state.playbackChordIndex += 1
    if state.playbackChordIndex == $('.chord').length
      state.playbackChordIndex = 0

    currentChord().addClass('playback-active')

  decrementChord = ->
    currentChord().removeClass('playback-active')

    state.playbackChordIndex -= 1
    if state.playbackChordIndex == -1
      state.playbackChordIndex = $('.chord').length - 1

    currentChord().addClass('playback-active')

  playChord = ->
    play s11.chord.create(currentChordData(), 4)

  $('body').keydown (e) ->
    if not state.isEditing
      e.preventDefault()
      if e.keyCode == 32 # Space
        playChord()
      if e.keyCode == 37 # Left
        decrementChord()
      if e.keyCode == 39 # Right
        incrementChord()

  #REDRAW function - calls upon draw() from /draw.coffee
  refresh = ->
    file = parser.parseString $('#input').val()

    replacements = initAlts file.alts if _.isNull replacements
    state.replacements = replacements

    draw location, file, state

    $('#edit').click ->
      state.isEditing = not state.isEditing
      refresh()
      if state.isEditing
        $('#inputCol').show()
        $('#outputCol').addClass('col-md-6')
        currentChord().removeClass('playback-active')
        state.playbackChordIndex = 0
      else
        $('#inputCol').hide()
        $('#outputCol').removeClass('col-md-6')
        currentChord().addClass('playback-active')
    
    #SWAP IN alts ON CLICK
    $('.alts').click ->
      chord = _.unescape $(this).attr('data-chord')

      $('#alternatesModal .modal-body').html generateAltsModal file.alts, chord, state

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

    if not state.isEditing
      currentChord().addClass('playback-active')

  $ ->
    #
    # EXAMPLE is imported from /example.coffee
    $('#input').val(example)
    
    #
    # INITIAL draw
    refresh()

    #
    # CONSTANT BEHAVIORAL ASSIGNMENTS
    $('#input').keyup refresh

    $('#settings').click ->
      $("[name='toggle-settings']").bootstrapSwitch('toggleState')

    $("[name='toggle-settings']").on 'switchChange.bootstrapSwitch', (event, bool)->
      state.showSettings = not state.showSettings
      bool = state.showSettings
      if bool
        $('#switches').slideDown()
      else
        $('#switches').slideUp()

    #
    # TRANSPOSE
    $('#transposeUp').click ->
      state.requestedKey = s11.note.create( $('#currentKey').html() ).sharp().clean().name
      refresh()

    $('#transposeDown').click ->
      state.requestedKey = s11.note.create( $('#currentKey').html() ).flat().clean().name
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
    switchHandler = (attr) ->
      (event, bool) ->
        state[attr] = bool
        refresh()

    $("[name='toggle-chords']").on 'switchChange.bootstrapSwitch', switchHandler('showChords')

    $("[name='toggle-lyrics']").on 'switchChange.bootstrapSwitch', switchHandler('showLyrics')
    
    $("[name='toggle-muted']").on 'switchChange.bootstrapSwitch', switchHandler('smartMode')
    
    $("[name='toggle-section']").on 'switchChange.bootstrapSwitch', switchHandler('showSections')

    $("[name='toggle-alts']").on 'switchChange.bootstrapSwitch', switchHandler('showAlts')
    
    #
    # DONE ONCE AT STARTUP
    $("input.bs").bootstrapSwitch()


  generateAltsModal = (alts, chord, state) ->
    printChord = chord.replace(/'/g,'')
    printChord = transpose(state.originalKey, state.drawKey, printChord)

    fstring = ''
    fstring += "    <button type='button' class='btn btn-lg btn-link' disabled='disabled'>Replace</button>"
    fstring += "    <button type='button' class='btn btn-lg btn-default' id='resetChord' data-chord='#{_.escape chord}'>#{printChord}</button>"
    fstring += "    <button type='button' class='btn btn-lg btn-link' disabled='disabled'>with</button>"
    (
      fstring += "  <button type='button' class='btn btn-lg btn-default' data-chord='#{_.escape chord}' data-index='#{index}'>#{transpose(state.originalKey, state.drawKey, rep)}</button>"
    ) for rep, index in alts[chord]
    #fstring += "<br/><br/><hr/>"
    #fstring += "    <button type='button' class='btn btn-md btn-link'>Reset to</button>"
    #fstring += "    <button type='button' class='btn btn-md btn-default'>#{chord}</button>"
    return fstring