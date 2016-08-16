React = require 'react'

module.exports = React.createClass
  render: ->
    if @props.isEditing
      <button className="btn btn-md btn-success edit" onClick={@props.handleClick}>
        <span className="glyphicon glyphicon-play" /> Save
      </button>
    else
      <button className="btn btn-md btn-warning edit" onClick={@props.handleClick}>
        <span className="glyphicon glyphicon-pencil" /> Edit
      </button>