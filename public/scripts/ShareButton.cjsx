React = require 'react'
ReactDOM = require 'react-dom'
Clipboard = require 'clipboard'
{ Button, Glyphicon, Modal, InputGroup, FormControl } = require 'react-bootstrap'

module.exports = React.createClass
  getInitialState: ->
    showModal: false

  componentDidMount: ->
    clipboard = new Clipboard '#copy-share-link'

  toggleModal: ->
    @setState showModal: not @state.showModal, showTooltip: false

  render: ->
    shareLink = "https://markato.studio/?song=#{@props.songId}"
    <div>
      <Button bsStyle="primary" className="share" onClick={@toggleModal}>
        <Glyphicon glyph="share-alt" /> Share
      </Button>
      <Modal show={@state.showModal}
             onHide={@toggleModal}
             className="share-modal"
      >
        <Modal.Body>
          <p>Share your song using the following link:</p>
          <InputGroup>
            <FormControl id="share-link" type="text" value={shareLink} readOnly />
            <InputGroup.Button>
              <Button id="copy-share-link" ref="copyShareLink" data-clipboard-target="#share-link">
                <Glyphicon glyph="copy" />
              </Button>
            </InputGroup.Button>
          </InputGroup>
        </Modal.Body>
        <Modal.Footer>
          <a href="#" onClick={@toggleModal}>Close</a>
        </Modal.Footer>
      </Modal>
    </div>