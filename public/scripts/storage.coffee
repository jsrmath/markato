_ = require 'underscore'

storage = window.localStorage

unless storage?
  storage = {}
  window.alert "Your browser does not support local storage.  You can still use Markato but you will not be able to create and save new songs."

get = (key) ->
  JSON.parse storage[key] if storage[key]?

set = (key, val) ->
  storage[key] = JSON.stringify val

defaults = (obj) ->
  _.mapObject obj, (val, key) ->
    unless key is 'currentUser'
      get(key) ? set(key, val)

synchronize = (state) ->
  _.each state, (val, key) ->
    set key, val

module.exports = { get, set, defaults, synchronize }