window.$ = window.jQuery = require 'jquery'
audio = require 'sharp11-web-audio'
React = require 'react'
ReactDOM = require 'react-dom'
MarkatoPage = require './MarkatoPage'

require 'bootstrap/dist/js/bootstrap'

audio.init (err, fns) ->
  if err then alert err
  {play, stop} = fns

  ReactDOM.render(
    <MarkatoPage play={play} stop={stop} />,
    document.getElementById 'body'
  )
