_ = require 'underscore'
React = require 'react'
firebase = require 'firebase/app'
{ Navbar, Nav, NavItem, NavDropdown, MenuItem } = require 'react-bootstrap'
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
      <NavDropdown title="Select Song">
        {@songListItems()}
        <li role="separator" className="divider"></li>
        <NavItem href="#" onClick={@props.newSong}>New Song</NavItem>
      </NavDropdown>

  logout: ->
    firebase.auth().signOut().then =>
      window.location.reload()

  welcome: ->
    if @props.currentUser
      <Nav className="navbar-right">
        <NavItem disabled className="navbar-username">{@props.currentUser.displayName}</NavItem>
        <NavItem href="#" onClick={@logout}>Log Out</NavItem>
      </Nav>

  render: ->
    <Navbar fixedTop>
      <Navbar.Header>
        <Navbar.Brand>
          <img src="icon.png" className="nav-icon" />
          <span>Markato</span>
        </Navbar.Brand>
      </Navbar.Header>
      <Nav>
        {@songList()}
        <NavItem href="#" onClick={@toggleTutorial}>Tutorial</NavItem>
      </Nav>
      {@welcome()}
      <TutorialModal show={@state.showTutorial} onHide={@toggleTutorial} />
    </Navbar>