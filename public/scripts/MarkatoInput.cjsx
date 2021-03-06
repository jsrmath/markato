React = require 'react'
autosize = require 'autosize'

module.exports = React.createClass
  componentDidMount: ->
    autosize $ '.markato-input'

  componentDidUpdate: ->
    autosize.update $ '.markato-input'

  render: ->
    <textarea className="form-control markato-input"
              value={@props.input}
              onChange={@props.handleInput} />
