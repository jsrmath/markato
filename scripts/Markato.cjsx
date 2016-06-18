React = require 'react'
ReactDOM = require 'react-dom'
parser = require './parser'
Switches = require './Switches'
MarkatoOutput = require './MarkatoOutput'
MarkatoInput = require './MarkatoInput'
EditButton = require './EditButton'

module.exports = React.createClass
  getInitialState: ->
    isEditing: true
    showSections: true
    fade: true
    showLyrics: true
    showChords: true
    showAlts: true
    displayKey: ''
    input: require './example'

  handleInput: (e) ->
    @setState input: e.target.value

  parsedInput: ->
    parser.parseString @state.input

  toggleState: (key) ->
    => @setState "#{key}": not @state[key]

  render: ->
    <div className="container">
      <div className="row">
        <Transposer />
        <Switches />
      </div>
      <div className="row">
        <div className={if @state.isEditing then "col-md-6" else "col-md-12"}>
          <EditButton isEditing={@state.isEditing} handleClick={@toggleState 'isEditing'} />
          <MarkatoOutput song={@parsedInput()}
                         showSections={@state.showSections}
                         fade={@state.fade}
                         showLyrics={@state.showLyrics}
                         showChords={@state.showChords}
                         showAlts={@state.showAlts}
                         displayKey={@state.displayKey} />
        </div>
        {<div className="col-md-6">
          <MarkatoInput input={@state.input}
                        handleInput={@handleInput} />
        </div> if @state.isEditing}
      </div>
    </div>
