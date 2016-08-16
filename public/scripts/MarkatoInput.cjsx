React = require 'react'

module.exports = React.createClass
  render: ->
    <textarea rows="30"
              className="form-control markato-input"
              value={@props.input}
              onChange={@props.handleInput} />
