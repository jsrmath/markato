React = require 'react'
firebase = require 'firebase/app'
{ Grid, Row, Col, Well, Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  login: ->
    provider = new firebase.auth.GoogleAuthProvider()
    firebase.auth().signInWithRedirect(provider)

  render: ->
    <Grid className="splash">
      <Row>
        <Col md=12>
          <div className="page-header">
            <h1>Markato <small>software for songwriters</small></h1>
          </div>
        </Col>
      </Row>
      <Row>
        <Col md=8>
          <Well className="splash-well">
            <ul className="splash-list">
              <li>
                <Glyphicon glyph="pencil" /> 
                Simple, powerful, and concise format for writing lyrics and chords
              </li>
              <li>
                <Glyphicon glyph="th" /> 
                Customizable interface for displaying, transposing, and printing your songs
              </li>
              <li>
                <Glyphicon glyph="play-circle" /> 
                Play through the chords of your song with arrow keys and spacebar
              </li>
            </ul>
          </Well>
        </Col>
        <Col md=4>
          <Well className="splash-well signin-well">
            <img onClick={@login} src="signin.png" className="signin" />
          </Well>
        </Col>
      </Row>
    </Grid>
