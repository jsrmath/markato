_ = require 'underscore'

module.exports.init = (firebase, user) ->
  getUserBucket: (callback) ->
    return callback(null) unless user?

    firebase.database().ref("/users/#{user.uid}").once('value')
    .then (snapshot) =>
      callback snapshot.val()
    .catch (err) =>
      console.log err
      alert err

  setUserBucket: (obj) ->
    firebase.database().ref("/users/#{user.uid}").set(obj)
