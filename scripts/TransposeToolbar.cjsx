React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'
s11 = require 'sharp11'

module.exports = React.createClass
  render: ->
    sharp = s11.note.create(@props.displayKey).sharp().clean().name
    flat = s11.note.create(@props.displayKey).flat().clean().name

    <small className="transpose-toolbar">
      <span> in</span>
      <span onClick={@props.setDisplayKey flat} className="glyphicon glyphicon-triangle-left clickable-color transpose-down" />
      <span onClick={@props.showTransposeModal} className="transpose-key clickable-color">{@props.displayKey}</span>
      <span onClick={@props.setDisplayKey sharp} className="glyphicon glyphicon-triangle-right clickable-color transpose-up" />
    </small>