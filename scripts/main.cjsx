window.$ = window.jQuery = require 'jquery'
audio = require 'sharp11-web-audio'
React = require 'react'
ReactDOM = require 'react-dom'
Markato = require './Markato'

require 'bootstrap/dist/js/bootstrap'
require 'bootstrap-switch/dist/js/bootstrap-switch'

audio.init (err, fns) ->
  if err then alert err
  {play, stop} = fns

  ReactDOM.render(
    <Markato play={play} stop={stop} />,
    document.getElementById 'main'
  )
