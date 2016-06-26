React = require 'react'
ReactDOM = require 'react-dom'

module.exports = React.createClass
  render: ->
    <button className="btn btn-md btn-danger delete" onClick={@props.handleClick}>
      <span className="glyphicon glyphicon-trash" /> Delete
    </button>