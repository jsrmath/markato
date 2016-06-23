React = require 'react'
ReactDOM = require 'react-dom'

module.exports = React.createClass
  render: ->
    if @props.isEditing
      <button className="btn btn-success edit" onClick={@props.handleClick}>
        <span className="glyphicon glyphicon-play" /> Save
      </button>
    else
      <button className="btn btn-warning edit" onClick={@props.handleClick}>
        <span className="glyphicon glyphicon-pencil" /> Edit
      </button>