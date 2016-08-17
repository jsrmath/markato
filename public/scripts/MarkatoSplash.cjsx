React = require 'react'
firebase = require 'firebase/app'

module.exports = React.createClass
  login: ->
    provider = new firebase.auth.GoogleAuthProvider()
    provider.addScope('https://www.googleapis.com/auth/plus.login')
    firebase.auth().signInWithRedirect(provider)

  render: ->
    <div className="container splash">
      <div className="row container">
        <div className="page-header">
          <h1>Markato <small>software for songwriters</small></h1>
        </div>
      </div>
      <div className="row">
        <div className="col-md-8">
          <div className="well splash-well">
            <ul className="splash-list">
              <li>
                <span className="glyphicon glyphicon-pencil" /> 
                Simple, powerful, and concise format for writing lyrics and chords
              </li>
              <li>
                <span className="glyphicon glyphicon-th" /> 
                Customizable interface for displaying, transposing, and printing your songs
              </li>
              <li>
                <span className="glyphicon glyphicon-play-circle" /> 
                Play through the chords of your song with arrow keys and spacebar
              </li>
            </ul>
          </div>
        </div>
        <div className="col-md-4">
          <div className="well splash-well signin-well">
            <img onClick={@login} src="signin.png" className="signin" />
          </div>
        </div>
      </div>
    </div>
