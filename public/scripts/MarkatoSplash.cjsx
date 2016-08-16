React = require 'react'
firebase = require 'firebase/app'

module.exports = React.createClass
  login: ->
    provider = new firebase.auth.GoogleAuthProvider()
    provider.addScope('https://www.googleapis.com/auth/plus.login')
    firebase.auth().signInWithRedirect(provider)

  content: ->
    if @props.currentUser
      <h1>Create a song</h1>
    else
      <button onClick={@login}>Log In</button>

  render: ->
    <div>
      {@content()}
    </div>
