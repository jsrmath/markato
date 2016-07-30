_ = require 'underscore'
React = require 'react'
ReactDOM = require 'react-dom'

module.exports = React.createClass
  songList: ->
    _.map @props.getSongNames(), (song, index) =>
      classes = "active" if @props.currentSongIndex is index
      <li className={classes} key={index} onClick={@props.handleSongSelect index}><a href="#">{song}</a></li>

  render: ->
    <nav className="navbar navbar-default navbar-fixed-top">
      <div className="container">
        <ul className="nav navbar-nav">
          <a className="navbar-brand">Markato</a>
          <li className="dropdown">
            <a href="#" className="dropdown-toggle" data-toggle="dropdown">
              Select Song<span className="caret" />
            </a>
            <ul className="dropdown-menu">
              {@songList()}
              <li role="separator" className="divider"></li>
              <li onClick={@props.newSong}><a href="#">New Song</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>