React = require 'react'
ReactDOM = require 'react-dom'
Modal = require 'react-bootstrap-modal'
_ = require 'underscore'
classNames = require 'classnames'

module.exports = React.createClass
  renderChord: (chord, isSelected, index) ->
    classes = classNames ['btn', 'btn-lg', 'btn-default': not isSelected, 'btn-info': isSelected]
    <button className={classes} onClick={@props.selectAlt index}>{chord}</button>

  renderAlts: ->
    _.map @props.alts, (alt, index) =>
      @renderChord alt, index is @props.selected, index

  render: ->
    classes = classNames ['alts-modal', 'modal-visible': @props.show]
    <Modal show={@props.show}
           onHide={@props.onHide}
           aria-labelledby="ModalHeader"
           className={classes}
    >
      <Modal.Header>
        <Modal.Title id="ModalHeader">Alternates</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <button className="btn btn-lg btn-link" disabled="disabled">Replace</button>
        {@renderChord @props.chord, not @props.selected?, null}
        <button className="btn btn-lg btn-link" disabled="disabled">with</button>
        <div className="btn-group">
          {@renderAlts()}
        </div>
      </Modal.Body>
      <Modal.Footer>
        <Modal.Dismiss className="btn btn-default">Cancel</Modal.Dismiss>
      </Modal.Footer>
    </Modal>
