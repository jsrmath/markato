React = require 'react'
_ = require 'underscore'
classNames = require 'classnames'
{ Button, Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  getInitialState: ->
    showSettings: false

  toggleSettings: ->
    @setState showSettings: not @state.showSettings

  fontSize: ->
    <Button onClick={@props.adjustFontSize}>
      <Glyphicon glyph="text-size" /> Font Size
    </Button>

  switches: ->
    _.map @props.switches, (switchData) ->
      {key, label, active, handleClick} = switchData

      <Button className="toggle-button" key={key} onClick={handleClick}>
        <Glyphicon glyph={if active then 'ok' else 'remove'} /> {label}
      </Button>

  render: ->
    <div className={classNames 'switches', 'dropup': @state.showSettings}>
      <Button bsStyle="info" onClick={@toggleSettings}>
        Display <span className="caret"></span>
      </Button>
      {@fontSize() if @state.showSettings}
      {@switches() if @state.showSettings}
    </div>