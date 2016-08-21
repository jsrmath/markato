_ = require 'underscore'
React = require 'react'
firebase = require 'firebase/app'
TutorialModal = require './TutorialModal'

module.exports = React.createClass
  getInitialState: ->
    showTutorial: false

  toggleTutorial: ->
    @setState showTutorial: not @state.showTutorial

  songListItems: ->
    _.map @props.getSongNames(), (song, index) =>
      classes = "active" if @props.currentSongIndex is index
      <li className={classes} key={index} onClick={@props.handleSongSelect index}><a href="#">{song}</a></li>

  songList: ->
    if @props.currentUser
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
    firebase.auth().signOut().then =>
      window.location.reload()

  welcome: ->
    if @props.currentUser
      <ul className="nav navbar-nav navbar-right">
        <li>
          <p className="navbar-text">{@props.currentUser.displayName}</p>
        </li>
        <li>
          <a href="#" onClick={@logout}>Log Out</a>
        </li>
      </ul>

  render: ->
    <nav className="navbar navbar-default navbar-fixed-top">
      <div className="container">
        <ul className="nav navbar-nav">
          <a className="navbar-brand">
            <img src="icon.png" className="nav-icon" />
            <span>Markato</span>
          </a>
          {@songList()}
          <li><a href="#" onClick={@toggleTutorial}>Tutorial</a></li>
        </ul>
        {@welcome()}
      </div>
      <TutorialModal show={@state.showTutorial} onHide={@toggleTutorial} />
    </nav>