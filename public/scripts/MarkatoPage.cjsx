_ = require 'underscore'
React = require 'react'
memoize = require 'memoizee'
uid = require 'uid'
{ Grid, Row, Col, Alert } = require 'react-bootstrap'
parser = require './parser'
MarkatoApp = require './MarkatoApp'
MarkatoSplash = require './MarkatoSplash'
MarkatoNav = require './MarkatoNav'
MarkatoFooter = require './MarkatoFooter'
example = require './example'

parse = memoize parser.parseString, primitive: true

defaultDisplaySettings =
  showChords: true
  showLyrics: true
  showFade: true
  showSections: true
  showAlternates: true
  showUkulele: false
  fontSize: 'md'

formatUserBucket = (userBucket) ->
  songs: userBucket.songs ? []
  currentSongIndex: userBucket.currentSongIndex

module.exports = React.createClass
  getInitialState: ->
    state = 
      if @props.userBucket?
        formatUserBucket @props.userBucket
      else
        songs: [
          name: "I Wanna Hold Your Hand"
          content: example
          uid: uid()
        ]
        currentSongIndex: 0

    state.sharedSong = @props.sharedSong
    state.sharedSongDisplaySettings = defaultDisplaySettings
    state

  componentDidMount: ->
    # If we have a new account, save the default song that gets loaded
    if @props.currentUser and not @props.userBucket
      @saveCurrentSong()

  componentWillReceiveProps: (nextProps) ->
    if nextProps.userBucket?
      @setState formatUserBucket nextProps.userBucket

  getSongNames: ->
    _.pluck @state.songs, 'name'

  getCurrentSong: ->
    if @state.currentSongIndex > -1
      song = @state.songs[@state.currentSongIndex]
    else
      null

  getDisplaySettings: ->
    if @state.sharedSong
      @state.sharedSongDisplaySettings
    else
      _.defaults @getCurrentSong()?.displaySettings or {}, defaultDisplaySettings

  setDisplaySetting: (key, val) ->
    if @state.sharedSong
      displaySettings = @state.sharedSongDisplaySettings
      displaySettings[key] = val
      @setState sharedSongDisplaySettings: displaySettings
    else
      song = @getCurrentSong()
      song.displaySettings = @getDisplaySettings()
      song.displaySettings[key] = val
      @setCurrentSong(song)

  setCurrentSong: (song) ->
    songs = @state.songs
    songs[@state.currentSongIndex] = song
    @setState songs: songs
    @saveCurrentSong()

  updateCurrentSong: (content) ->
    song = @getCurrentSong()
    song.content = content
    song.name = @parsedCurrentSong().meta.TITLE if @parsedCurrentSong().meta.TITLE
    @setCurrentSong(song)

  toggleDisplaySwitch: (key) ->
    @setDisplaySetting key, not @getDisplaySettings()[key]

  adjustFontSize: ->
    @setDisplaySetting 'fontSize', switch @getDisplaySettings().fontSize
      when 'md' then 'lg'
      when 'lg' then 'sm'
      else 'md'

  newSongContent: (title) ->
    """
    ##TITLE  #{title}
    ##ARTIST #{@props.currentUser.displayName}
    ##KEY    C
    """

  newSong: ->
    songs = @state.songs
    title = prompt('Enter a title')
    if title
      songs.push
        name: title
        content: @newSongContent title
        uid: uid()
      @setState songs: songs, currentSongIndex: songs.length - 1, @saveCurrentSongAndIndex

  deleteSong: ->
    if confirm('Are you sure you want to delete this song?')
      index = @state.currentSongIndex
      songs = @state.songs
      songs.splice index, 1

      newIndex = index - 1
      # Only decrement index to -1 if there are no songs
      newIndex = 0 if newIndex is -1 and songs.length isnt 0

      @setState songs: songs, currentSongIndex: newIndex, @saveUserBucket

  parsedCurrentSong: ->
    parse @getCurrentSong().content

  handleSongSelect: (index) ->
    @setState currentSongIndex: index, @saveCurrentSongIndex

  saveUserBucket: ->
    @props.setUserBucketKey 'songs', @state.songs
    @saveCurrentSongIndex()

  saveCurrentSongAndIndex: ->
    @saveCurrentSong()
    @saveCurrentSongIndex()

  saveCurrentSong: ->
    @props.setUserBucketKey "songs/#{@state.currentSongIndex}", @getCurrentSong()

  deleteCurrentSong: ->
    @props.setUserBucketKey "songs/#{@state.currentSongIndex}", null

  saveCurrentSongIndex: ->
    @removeSharedSong() # When a user selects a song, remove the shared song if there is one
    @props.setUserBucketKey 'currentSongIndex', @state.currentSongIndex

  shareableSongId: ->
    return "#{@getCurrentSong().uid}#{@props.currentUser.uid}"

  removeSharedSong: ->
    if @state.sharedSong
      window.location = '/'

  sharedSongAlert: ->
    <Grid><Row><Col md=12><Alert bsStyle="warning">{
      if @props.currentUser
        <p>
          You are viewing a Markato song that someone has shared with you.
          To return to your own songs, select one from the "Select Song" dropdown or click 
          <span className="clickable-color" onClick={@removeSharedSong}>here</span>.
        </p>
      else
        <p>
          This song was written with a free web app called Markato.
          Use the arrow keys and spacebar to play through the chords.
          To learn more about Markato, click 
          <span className="clickable-color" onClick={@removeSharedSong}>here</span>.
        </p>
    }</Alert></Col></Row></Grid>

  content: ->
    displaySettingsProps =
      displaySettings: @getDisplaySettings()
      toggleDisplaySwitch: @toggleDisplaySwitch
      adjustFontSize: @adjustFontSize

    if @state.sharedSong
      sharedSongContent = @state.sharedSong.content
      <div>
        {@sharedSongAlert()}
        <MarkatoApp play={@props.play}
                    input={sharedSongContent}
                    parsedInput={parse sharedSongContent}
                    {...displaySettingsProps}
                    readOnly />
      </div>
    else
      if @props.currentUser
        if @getCurrentSong()
          <MarkatoApp play={@props.play}
                      input={@getCurrentSong().content}
                      parsedInput={@parsedCurrentSong()}
                      handleInput={@updateCurrentSong}
                      deleteSong={@deleteSong}
                      shareableSongId={@shareableSongId()}
                      {...displaySettingsProps} />
        else
          <div className="container">
            <p>You don't have any songs.  Why don't you create a <a href="#" onClick={@newSong}>new song</a>?</p>
          </div>
      else
        <MarkatoSplash />

  render: ->
    <div>
      <MarkatoNav currentSongIndex={if @state.sharedSong then -1 else @state.currentSongIndex}
                  songNames={@getSongNames()}
                  handleSongSelect={@handleSongSelect}
                  newSong={@newSong}
                  currentUserDisplayName={@props.currentUser?.displayName} />
      {@content()}
      <MarkatoFooter />
    </div>