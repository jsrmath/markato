React = require 'react'
_ = require 'underscore'
s11 = require 'sharp11'
{ Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  render: ->
    sharp = s11.note.create(@props.displayKey).sharp().clean().name
    flat = s11.note.create(@props.displayKey).flat().clean().name

    <small className="transpose-toolbar">
      <span> in</span>
      <Glyphicon onClick={=> @props.setDisplayKey flat} glyph="triangle-left" className="clickable-color transpose-down" />
      <span onClick={@props.showTransposeModal} className="transpose-key clickable-color">{@props.displayKey}</span>
      <Glyphicon onClick={=> @props.setDisplayKey sharp} glyph="triangle-right" className="clickable-color transpose-up" />
    </small>