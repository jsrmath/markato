React = require 'react'

module.exports = React.createClass
  render: ->
    <button className="btn btn-md btn-danger delete" onClick={@props.handleClick}>
      <span className="glyphicon glyphicon-trash" /> Delete
    </button>