React = require 'react'
{ Modal, Button, ButtonGroup } = require 'react-bootstrap'
_ = require 'underscore'
SelectableButton = require './SelectableButton'

module.exports = React.createClass
  renderChord: (chord, isSelected, index) ->
    <SelectableButton isSelected={isSelected} onClick={=> @props.selectAlt index} key={chord}>
      {@props.formatChord chord}
    </SelectableButton>

  renderAlts: ->
    _.map @props.alts, (alt, index) =>
      @renderChord alt, index is @props.selected, index

  render: ->
    <Modal show={@props.show}
           onHide={@props.onHide}
           aria-labelledby="ModalHeader"
           className="alts-modal"
    >
      <Modal.Header>
        <Modal.Title>Alternates</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Button bsStyle="link" bsSize="large" disabled>Replace</Button>
        {@renderChord @props.chord, not @props.selected?, null}
        <Button bsStyle="link" bsSize="large" disabled>with</Button>
        <ButtonGroup>
          {@renderAlts()}
        </ButtonGroup>
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={@props.onHide}>Cancel</Button>
      </Modal.Footer>
    </Modal>
