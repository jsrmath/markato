// audio.js - Plagiarized from jsrmath/sharp11-client
// I'll modularize it and put it on npm someday

var s11 = require('sharp11');
var _ = require('underscore');
var WAAClock = require('waaclock');
var base64 = require('base64-arraybuffer');
var async = require('async');

var pianoSoundfont;
if (new Audio().canPlayType('audio/ogg') !== '') {
  pianoSoundfont = require('../soundfonts/acoustic_grand_piano-ogg');
}
else {
  pianoSoundfont = require('../soundfonts/acoustic_grand_piano-mp3');
}

var scaleDelay = .5;
var defaultDuration = .3;

window.AudioContext = window.AudioContext || window.webkitAudioContext;

var ctx = new AudioContext();
var clock = new WAAClock(ctx);
clock.start();

module.exports.init = function (func) {
  var buffers = {};

  var loadBuffer = function (note, callback) {
    ctx.decodeAudioData(base64.decode(pianoSoundfont[note]), function(buffer) {
      buffers[note] = buffer;
      callback();
    }, function(err) {
      callback(err);
    });
  };

  async.each(_.keys(pianoSoundfont), loadBuffer, function (err) {
    var sources = [];
    var events = [];

    if (err) alert(err);

    var getBuffer = function (note) {
      return buffers[note.clean().withAccidental('b').fullName];
    };

    var playNote = function (note, start, duration, callback) {
      var src = ctx.createBufferSource();
      var gainNode = ctx.createGain();

      src.buffer = getBuffer(note);
      src.connect(ctx.destination);
      src.start(start, 0, duration);
      sources.push(src);

      if (callback) {
        events.push(clock.callbackAtTime(_.partial(callback, note), start));
      }
    };

    var play = function (obj, start, duration, callback) {
      start = ctx.currentTime + (start || 0);
      duration = duration || defaultDuration;

      if (callback) callback = _.partial(callback, obj);

      if (s11.chord.isChord(obj)) {
        _.each(obj.chord, function (note) {
          playNote(note, start, duration, callback);
        });
      }
      else if (s11.scale.isScale(obj)) {
        _.each(obj.scale.concat(obj.root.transpose('P8')), function (note, i) {
          playNote(note, start + i * scaleDelay, duration, callback);
        });
      }
      else if (obj instanceof Array) {
        _.each(obj, function (note) {
          playNote(note, start, duration, callback);
        });
      }
      else { // Assume note
        playNote(s11.note.create(obj), start, duration, callback);
      }
    };

    var stop = function () {
      _.invoke(sources, 'stop');
      _.invoke(events, 'clear');
      sources = events = [];
    };

    func(play, stop);
  });
};