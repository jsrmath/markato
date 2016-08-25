React = require 'react'
{ Modal, Button, ButtonGroup } = require 'react-bootstrap'
_ = require 'underscore'
SelectableButton = require './SelectableButton'

module.exports = React.createClass
  renderKeys: ->
    keys = [['C'],['C#','Db'],['D'],['D#','Eb'],['E'],['F'],['F#','Gb'],['G'],['G#','Ab'],['A'],['A#','Bb'],['B']]
    _.map keys, (keyGroup, i) =>
      <ButtonGroup key={i}>
        {_.map keyGroup, (key) =>
          <SelectableButton isSelected={key is @props.displayKey} key={key} onClick={=> @props.setDisplayKey key}>
            {key}
          </SelectableButton>
        }
      </ButtonGroup>

  reset: ->
    @props.reset()
    @props.onHide()

  render: ->
    <Modal show={@props.show}
           onHide={@props.onHide}
           aria-labelledby="ModalHeader"
           className="transpose-modal"
    >
      <Modal.Header>
        <Modal.Title>Transpose</Modal.Title>
      </Modal.Header>
      <Modal.Body className="btn-toolbar">
        {@renderKeys()}
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={@reset}>
          Reset to {@props.originalKey}
        </Button>
      </Modal.Footer>
    </Modal>
