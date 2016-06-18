React = require 'react'
ReactDOM = require 'react-dom'
parser = require './parser'
Switches = require './Switches'
MarkatoOutput = require './MarkatoOutput'
MarkatoInput = require './MarkatoInput'

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

  render: ->
    <div className="container">
      <div className="row">
        <Switches />
      </div>
      <div className="row">
        <div className="col-md-6">
          <MarkatoOutput song={@parsedInput()}
                         showSections={@state.showSections}
                         fade={@state.fade}
                         showLyrics={@state.showLyrics}
                         showChords={@state.showChords}
                         showAlts={@state.showAlts}
                         displayKey={@state.displayKey} />
        </div>
        <div className="col-md-6">
          <MarkatoInput show={@state.isEditing}
                        input={@state.input}
                        handleInput={@handleInput} />
        </div>
      </div>
    </div>
