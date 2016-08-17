window.$ = window.jQuery = require 'jquery'
audio = require 'sharp11-web-audio'
React = require 'react'
ReactDOM = require 'react-dom'
MarkatoPage = require './MarkatoPage'
Loading = require './Loading'
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

ReactDOM.render <Loading />, document.getElementById 'body'

audio.init (err, fns) ->
  if err then alert err
  {play} = fns

  firebase.auth().getRedirectResult().then =>
    user = firebase.auth().currentUser
    storage = storageModule.init(firebase, user)
    storage.getUserBucket (userBucket) =>
      ReactDOM.render(
        <MarkatoPage play={play}
                     currentUser={user}
                     userBucket={userBucket}
                     setUserBucketKey={storage.setUserBucketKey} />,
        document.getElementById 'body'
      )

