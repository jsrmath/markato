window.$ = window.jQuery = require 'jquery'
audio = require 'sharp11-web-audio'
React = require 'react'
ReactDOM = require 'react-dom'
MarkatoPage = require './MarkatoPage'
firebase = require 'firebase/app'
storageModule = require './storage'

require 'firebase/auth'
require 'firebase/database'
require 'bootstrap/dist/js/bootstrap'

firebase.initializeApp
  apiKey: "AIzaSyBsjSVy449KcL1L4u62uH58hWq8pRIOPik",
  authDomain: "markato-42764.firebaseapp.com",
  databaseURL: "https://markato-42764.firebaseio.com",
  storageBucket: "markato-42764.appspot.com"

audio.init (err, fns) ->
  if err then alert err
  {play, stop} = fns

  firebase.auth().onAuthStateChanged (user) =>
    storage = storageModule.init(firebase, user)
    storage.getUserBucket (userBucket) =>
      ReactDOM.render(
        <MarkatoPage play={play}
                     stop={stop}
                     currentUser={user}
                     userBucket={userBucket}
                     setUserBucket={storage.setUserBucket} />,
        document.getElementById 'body'
      )
