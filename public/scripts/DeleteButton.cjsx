React = require 'react'
{ Button, Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  shouldComponentUpdate: ->
    false

  render: ->
    <Button bsStyle="danger" className="delete" onClick={@props.handleClick}>
      <Glyphicon glyph="trash" /> Delete
    </Button>