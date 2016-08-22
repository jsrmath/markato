React = require 'react'
_ = require 'underscore'
classNames = require 'classnames'

module.exports = React.createClass
  getInitialState: ->
    showSwitches: false

  toggleSwitches: ->
    @setState showSwitches: not @state.showSwitches

  switches: ->
    _.map @props.switches, (switchData) ->
      {key, label, active, handleClick} = switchData
      buttonClasses = classNames 'btn', 'btn-default', 'btn-md', 'toggle-button'
      glyphClasses = classNames 'glyphicon', 'glyphicon-ok': active, 'glyphicon-remove': not active

      <button className={buttonClasses} key={key} onClick={handleClick}>
        <span className={glyphClasses}></span> {label}
      </button>

  render: ->
    <div className={classNames 'switches', 'dropup': @state.showSwitches}>
      <button className="btn btn-info btn-md" onClick={@toggleSwitches}>
        Display <span className="caret"></span>
      </button>
      {@switches() if @state.showSwitches}
    </div>