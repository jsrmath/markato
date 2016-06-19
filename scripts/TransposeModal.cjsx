React = require 'react'
ReactDOM = require 'react-dom'
Modal = require 'react-bootstrap-modal'
_ = require 'underscore'
classNames = require 'classnames'

module.exports = React.createClass
  renderKeys: ->
    keys = [['C'],['C#','Db'],['D'],['D#','Eb'],['E'],['F'],['F#','Gb'],['G'],['G#','Ab'],['A'],['A#','Bb'],['B']]
    _.map keys, (keyGroup) =>
      <div className="btn-group">
        {_.map keyGroup, (key) =>
          selected = key is @props.displayKey
          classes = classNames ['btn', 'btn-lg', 'btn-default': not selected, 'btn-info': selected]
          <button className={classes} onClick={@props.setDisplayKey key}>{key}</button>
        }
      </div>

  render: ->
    classes = classNames ['transpose-modal', 'modal-visible': @props.show]
    <Modal show={@props.show}
           onHide={@props.onHide}
           aria-labelledby="ModalHeader"
           className={classes}
    >
      <Modal.Header>
        <Modal.Title id="ModalHeader">Transpose</Modal.Title>
      </Modal.Header>
      <Modal.Body className="btn-toolbar">
        {@renderKeys()}
      </Modal.Body>
      <Modal.Footer>
        <Modal.Dismiss className="btn btn-default" onClick={@props.reset}>
          Reset to {@props.originalKey}
        </Modal.Dismiss>
      </Modal.Footer>
    </Modal>
