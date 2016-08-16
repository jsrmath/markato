_ = require 'underscore'
React = require 'react'
firebase = require 'firebase/app'

module.exports = React.createClass
  songListItems: ->
    _.map @props.getSongNames(), (song, index) =>
      classes = "active" if @props.currentSongIndex is index
      <li className={classes} key={index} onClick={@props.handleSongSelect index}><a href="#">{song}</a></li>

  songList: ->
    if @props.currentUser and @props.getSongNames()
      <li className="dropdown">
        <a href="#" className="dropdown-toggle" data-toggle="dropdown">
          Select Song<span className="caret" />
        </a>
        <ul className="dropdown-menu">
          {@songListItems()}
          <li role="separator" className="divider"></li>
          <li onClick={@props.newSong}><a href="#">New Song</a></li>
        </ul>
      </li>

  logout: ->
    firebase.auth().signOut()

  welcome: ->
    if @props.currentUser
      <ul className="nav navbar-nav navbar-right">
        <li>
          <p className="navbar-text">Welcome, {@props.currentUser.displayName}</p>
        </li>
        <li>
          <a href="#" onClick={@logout}>Log Out</a>
        </li>
      </ul>

  render: ->
    <nav className="navbar navbar-default navbar-fixed-top">
      <div className="container">
        <ul className="nav navbar-nav">
          <a className="navbar-brand">Markato</a>
          {@songList()}
        </ul>
        {@welcome()}
      </div>
    </nav>