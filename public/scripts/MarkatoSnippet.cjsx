_ = require 'underscore'
React = require 'react'
parser = require './parser'
MarkatoContent = require './MarkatoContent'

module.exports = React.createClass
  getInitialState: ->
    showInput: true

  toggleInput: ->
    @setState showInput: not @state.showInput

  render: ->
    if @state.showInput
      <pre onClick={@toggleInput}>
        <small className="markato-snippet-help">Click to see Markato output</small>
        {@props.children}
      </pre>
    else
      <MarkatoContent song={parser.parseString @props.children}
                      onClick={@toggleInput} />