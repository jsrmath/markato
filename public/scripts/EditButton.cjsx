React = require 'react'
{ Button, Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  ifEditing: (editing, notEditing) ->
    if @props.isEditing then editing else notEditing

  render: ->
    <Button className="edit" bsStyle={@ifEditing 'success', 'warning'} onClick={@props.handleClick}>
      <Glyphicon glyph={@ifEditing 'play', 'pencil'} /> {@ifEditing 'Play', 'Edit'}
    </Button>