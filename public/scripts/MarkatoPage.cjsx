_ = require 'underscore'
React = require 'react'
memoize = require 'memoizee'
parser = require './parser'
MarkatoApp = require './MarkatoApp'
MarkatoSplash = require './MarkatoSplash'
MarkatoNav = require './MarkatoNav'
example = require './example'

parsedCurrentSong = memoize parser.parseString, primitive: true

formatUserBucket = (userBucket) ->
  songs: userBucket.songs ? []
  currentSongIndex: userBucket.currentSongIndex

module.exports = React.createClass
  getInitialState: ->
    if @props.userBucket?
      formatUserBucket @props.userBucket
    else
      songs: [
        name: "I Wanna Hold Your Hand [Example]"
        content: example
      ]
      currentSongIndex: 0

  componentWillReceiveProps: (nextProps) ->
    if nextProps.userBucket?
      @setState formatUserBucket nextProps.userBucket


  getSongNames: ->
    _.pluck @state.songs, 'name'

  getCurrentSong: ->
    if @state.currentSongIndex > -1
      @state.songs[@state.currentSongIndex]
    else
      null

  setCurrentSong: (song) ->
    songs = @state.songs
    songs[@state.currentSongIndex] = song
    @setState songs: songs
    @save()

  updateCurrentSong: (content) ->
    song = @getCurrentSong()
    song.content = content
    song.name = @parsedCurrentSong().meta.TITLE if @parsedCurrentSong().meta.TITLE
    @setCurrentSong(song)

  newSongContent: (title) ->
    """
    ##TITLE  #{title}
    ##ARTIST #{@props.currentUser.displayName}
    ##KEY    C

    #VERSE
    """

  newSong: ->
    songs = @state.songs
    title = prompt('Enter a title')
    if title
      songs.push
        name: title
        content: @newSongContent title
      @setState songs: songs, currentSongIndex: songs.length - 1, @save

  deleteSong: ->
    if confirm('Are you sure you want to delete this song?')
      index = @state.currentSongIndex
      songs = @state.songs
      songs.splice index, 1
      @setState songs: songs, currentSongIndex: index - 1, @save

  parsedCurrentSong: ->
    parsedCurrentSong @getCurrentSong().content

  handleSongSelect: (index) ->
    =>
      @setState currentSongIndex: index, @save

  save: ->
    @props.setUserBucket @state

  content: ->
    if @props.currentUser and @getCurrentSong()
      <MarkatoApp play={@props.play}
                  stop={@props.stop}
                  save={@save}
                  input={@getCurrentSong().content}
                  parsedInput={@parsedCurrentSong()}
                  handleInput={@updateCurrentSong}
                  deleteSong={@deleteSong} />
    else
      <MarkatoSplash currentUser={@props.currentUser} />

  render: ->
    <div>
      <MarkatoNav currentSongIndex={@state.currentSongIndex}
                  getSongNames={@getSongNames}
                  handleSongSelect={@handleSongSelect}
                  newSong={@newSong}
                  currentUser={@props.currentUser} />
      {@content()}
    </div>