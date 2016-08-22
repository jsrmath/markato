_ = require 'underscore'
React = require 'react'
memoize = require 'memoizee'
parser = require './parser'
MarkatoApp = require './MarkatoApp'
MarkatoSplash = require './MarkatoSplash'
MarkatoNav = require './MarkatoNav'
MarkatoFooter = require './MarkatoFooter'
example = require './example'

parse = memoize parser.parseString, primitive: true

formatUserBucket = (userBucket) ->
  songs: userBucket.songs ? []
  currentSongIndex: userBucket.currentSongIndex

module.exports = React.createClass
  getInitialState: ->
    if @props.userBucket?
      formatUserBucket @props.userBucket
    else
      songs: [
        name: "I Wanna Hold Your Hand"
        content: example
      ]
      currentSongIndex: 0

  componentDidMount: ->
    # If we have a new account, save the default song that gets loaded
    unless @props.userBucket?
      @saveCurrentSong()

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
    @saveCurrentSong()

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
    """

  newSong: ->
    songs = @state.songs
    title = prompt('Enter a title')
    if title
      songs.push
        name: title
        content: @newSongContent title
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
    => @setState currentSongIndex: index, @saveCurrentSongIndex

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
    @props.setUserBucketKey 'currentSongIndex', @state.currentSongIndex

  content: ->
    if @props.currentUser
      if @getCurrentSong()
        <MarkatoApp play={@props.play}
                    stop={@props.stop}
                    input={@getCurrentSong().content}
                    parsedInput={@parsedCurrentSong()}
                    handleInput={@updateCurrentSong}
                    deleteSong={@deleteSong} />
      else
        <div className="container">
          <p>You don't have any songs.  Why don't you create a <a href="#" onClick={@newSong}>new song</a>?</p>
        </div>
    else
      <MarkatoSplash />

  render: ->
    <div>
      <MarkatoNav currentSongIndex={@state.currentSongIndex}
                  getSongNames={@getSongNames}
                  handleSongSelect={@handleSongSelect}
                  newSong={@newSong}
                  currentUser={@props.currentUser} />
      {@content()}
      <MarkatoFooter />
    </div>