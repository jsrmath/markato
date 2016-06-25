React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'
classNames = require 'classnames'

module.exports = React.createClass
  switches: ->
    _.map @props.switches, (switchData) ->
      {key, label, active, handleClick} = switchData
      buttonClasses = classNames 'btn', 'btn-default', 'btn-md', 'toggle-button'
      glyphClasses = classNames 'glyphicon', 'glyphicon-ok': active, 'glyphicon-remove': not active

      <button className={buttonClasses} key={key} onClick={handleClick}>
        <span className={glyphClasses}></span> {label}
      </button>

  render: ->
    <div className="switches">
      {@switches()}
    </div>