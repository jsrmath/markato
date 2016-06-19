React = require 'react'
ReactDOM = require 'react-dom'
Switch = require 'react-bootstrap-switch'
_ = require 'underscore'
s11 = require 'sharp11'

module.exports = React.createClass
  render: ->
    sharp = s11.note.create(@props.displayKey).sharp().clean().name
    flat = s11.note.create(@props.displayKey).flat().clean().name

    <div className="transpose-toolbar btn-group">
      <button onClick={@props.setDisplayKey flat} className="btn btn-default btn-md">
        <span className="glyphicon glyphicon-chevron-left" />
      </button>
      <button onClick={@props.showTransposeModal} className="btn btn-info btn-md transpose-button">
        <span>{@props.displayKey}</span>
      </button>
      <button onClick={@props.setDisplayKey sharp} className="btn btn-default btn-md">
        <span className="glyphicon glyphicon-chevron-right" />
      </button>
    </div>