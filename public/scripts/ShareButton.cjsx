React = require 'react'
{ Button, Glyphicon } = require 'react-bootstrap'

module.exports = React.createClass
  shouldComponentUpdate: (nextProps) ->
    @props.songId isnt nextProps.songId

  share: ->
    alert("Share your song using the following link:\nhttps://markato.studio/?song=#{@props.songId}")

  render: ->
    <Button bsStyle="primary" className="delete" onClick={@share}>
      <Glyphicon glyph="share-alt" /> Share
    </Button>
