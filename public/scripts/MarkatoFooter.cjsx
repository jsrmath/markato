React = require 'react'
{ Grid, Row, Col } = require 'react-bootstrap'

module.exports = React.createClass
  render: ->
    <Grid><Row><Col md=12><footer><p>
      Markato is written and maintained by <a href="http://julianrosenblum.com">Julian Rosenblum</a>.
      Developers are encouraged to check out Markato on <a href="https://github.com/jsrmath/markato">GitHub</a>.
    </p></footer></Col></Row></Grid>
    