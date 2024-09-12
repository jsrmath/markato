React = require 'react'
{ Grid, Row, Col } = require 'react-bootstrap'

module.exports = React.createClass
  shouldComponentUpdate: ->
    false

  render: ->
    <Grid><Row><Col md=12><footer><p>
      Markato was written by <a href="http://julianrosenblum.com">Julian Rosenblum</a>.
      It is not being actively maintained so use at your own risk.
      Developers can check out Markato on <a href="https://github.com/jsrmath/markato">GitHub</a>.
    </p></footer></Col></Row></Grid>
    