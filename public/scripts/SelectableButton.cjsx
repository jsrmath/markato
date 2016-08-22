React = require 'react'
{ Button } = require 'react-bootstrap'

module.exports = React.createClass
  render: ->
    <Button bsStyle={if @props.isSelected then 'info' else 'default'}
            bsSize="large"
            onClick={@props.onClick}>
      {@props.children}
    </Button>
