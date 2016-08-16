React = require 'react'
firebase = require 'firebase/app'

module.exports = React.createClass
  login: ->
    provider = new firebase.auth.GoogleAuthProvider()
    provider.addScope('https://www.googleapis.com/auth/plus.login')
    firebase.auth().signInWithRedirect(provider)

  render: ->
    <div>
      <button onClick={@login}>Log In</button>
    </div>
