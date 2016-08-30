_ = require 'underscore'
React = require 'react'
firebase = require 'firebase/app'
{ Navbar, Nav, NavItem, NavDropdown, MenuItem } = require 'react-bootstrap'
TutorialModal = require './TutorialModal'

module.exports = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    _.some [
      @props.currentSongIndex isnt nextProps.currentSongIndex
      @props.songNames.toString() isnt nextProps.songNames.toString()
      @props.currentUserDisplayName isnt nextProps.currentUserDisplayName
      @state.showTutorial isnt nextState.showTutorial
    ]

  getInitialState: ->
    showTutorial: false

  toggleTutorial: ->
    @setState showTutorial: not @state.showTutorial

  songListItems: ->
    _.map @props.songNames, (song, index) =>
      classes = 'active' if @props.currentSongIndex is index
      <MenuItem className={classes} key={index} onClick={=> @props.handleSongSelect index}>{song}</MenuItem>

  songList: ->
    if @props.currentUserDisplayName
      <NavDropdown title="Select Song" id="select-song">
        {@songListItems()}
        <MenuItem role="separator" className="divider" />
        <MenuItem onClick={@props.newSong}>New Song</MenuItem>
      </NavDropdown>

  logout: ->
    firebase.auth().signOut().then =>
      window.location.reload()

  welcome: ->
    if @props.currentUserDisplayName
      <Nav className="navbar-right">
        <NavItem disabled className="navbar-username">{@props.currentUserDisplayName}</NavItem>
        <NavItem href="#" onClick={@logout}>Log Out</NavItem>
      </Nav>

  render: ->
    <Navbar fixedTop>
      <Navbar.Header>
        <Navbar.Brand>
          <a href="#"><img src="icon.png" className="nav-icon" /></a>
        </Navbar.Brand>
      </Navbar.Header>
      <Nav>
        {@songList()}
        <NavItem href="#" onClick={@toggleTutorial}>Tutorial</NavItem>
      </Nav>
      {@welcome()}
      <TutorialModal show={@state.showTutorial} onHide={@toggleTutorial} />
    </Navbar>