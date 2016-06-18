React = require 'react'
ReactDOM = require 'react-dom'
Switch = require 'react-bootstrap-switch'
_ = require 'underscore'

module.exports = React.createClass
  switches: ->
    _.map @props.switches, (switchData) ->
      {key, label, value, handleChange} = switchData
      <Switch key={key}
              state={value}
              onChange={handleChange}
              labelText={label}
              labelWidth="75px"
              inverse="true" />

  render: ->
    <div>
      {@switches()}
    </div>