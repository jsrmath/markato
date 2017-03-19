window.$ = window.jQuery = require 'jquery'
React = require 'react'
ReactDOM = require 'react-dom'
queryString = require 'query-string'
MarkatoPage = require './MarkatoPage'
Loading = require './Loading'
firebase = require 'firebase/app'
storageModule = require './storage'

require 'object-assign-shim'
require 'firebase/auth'
require 'firebase/database'
require 'bootstrap/dist/js/bootstrap'

USER_ID_LENGTH = 28
SONG_ID_LENGTH = 7

firebase.initializeApp
  apiKey: "AIzaSyBsjSVy449KcL1L4u62uH58hWq8pRIOPik",
  authDomain: "markato-42764.firebaseapp.com",
  databaseURL: "https://markato-42764.firebaseio.com",
  storageBucket: "markato-42764.appspot.com"

ReactDOM.render <Loading />, document.getElementById 'body'

handleSharedSongQueryString = (storage, callback) ->
  sharedSongId = queryString.parse(window.location.search).song
  if sharedSongId and sharedSongId.length is USER_ID_LENGTH + SONG_ID_LENGTH
    userId = sharedSongId.slice(SONG_ID_LENGTH)
    songId = sharedSongId.slice(0, SONG_ID_LENGTH)
    storage.getSharedSong userId, songId, callback
  else
    callback()

# Authenticate
firebase.auth().getRedirectResult().then =>
  user = firebase.auth().currentUser
  storage = storageModule.init(firebase, user)

  # Get user data
  storage.getUserBucket (userBucket) =>

    # Handle possible shared song
    handleSharedSongQueryString storage, (sharedSong) =>
      ReactDOM.render(
        <MarkatoPage currentUser={user}
                     userBucket={userBucket}
                     setUserBucketKey={storage.setUserBucketKey}
                     sharedSong={sharedSong} />,
        document.getElementById 'body'
      )
