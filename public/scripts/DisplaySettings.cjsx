React = require 'react'
_ = require 'underscore'
classNames = require 'classnames'
{ Button, Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  getInitialState: ->
    showSwitches: false

  toggleSwitches: ->
    @setState showSwitches: not @state.showSwitches

  switches: ->
    _.map @props.switches, (switchData) ->
      {key, label, active, handleClick} = switchData

      <Button className="toggle-button" key={key} onClick={handleClick}>
        <Glyphicon glyph={if active then 'ok' else 'remove'} /> {label}
      </Button>

  render: ->
    <div className={classNames 'switches', 'dropup': @state.showSwitches}>
      <Button bsStyle="info" onClick={@toggleSwitches}>
        Display <span className="caret"></span>
      </Button>
      {@switches() if @state.showSwitches}
    </div>