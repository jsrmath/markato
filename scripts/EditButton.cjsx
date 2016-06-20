React = require 'react'
ReactDOM = require 'react-dom'

module.exports = React.createClass
  render: ->
    if @props.isEditing
      <button className="btn btn-success edit" onClick={@props.handleClick}>
        <span className="glyphicon glyphicon-ok"></span> Save
      </button>
    else
      <button className="btn btn-info edit" onClick={@props.handleClick}>
        <span className="glyphicon glyphicon-pencil"></span> Edit
      </button>