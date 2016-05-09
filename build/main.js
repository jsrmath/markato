var _, draw, example, generateAltsModal, initAlts, location, parser, refresh, replacements, s11, state, transpose;

draw = require('./draw');

example = require('./example');

parser = require('./parser');

transpose = require('./transpose');

window.$ = window.jQuery = require('jquery');

_ = require('underscore');

s11 = require('sharp11');

require('bootstrap/dist/js/bootstrap');

require('bootstrap-switch/dist/js/bootstrap-switch');

location = '#canvas';

state = {
  showChords: true,
  showLyrics: true,
  showRepeats: false,
  showAlts: true,
  showSections: true,
  smartMode: true,
  requestedKey: null,
  isEditing: true,
  showSettings: true
};

replacements = null;

initAlts = function(obj) {
  var chord, i, len, ref;
  replacements = {};
  ref = _.keys(obj);
  for (i = 0, len = ref.length; i < len; i++) {
    chord = ref[i];
    replacements[chord] = null;
  }
  return replacements;
};

refresh = function() {
  var file;
  file = parser.parseString($('#input').val());
  if (_.isNull(replacements)) {
    replacements = initAlts(file.alts);
  }
  state.replacements = replacements;
  draw(location, file, state);
  $('#edit').click(function() {
    state.isEditing = !state.isEditing;
    if (state.isEditing) {
      $('#inputCol').show();
    } else {
      $('#inputCol').hide();
    }
    if (state.isEditing) {
      $('#outputCol').addClass('col-md-6');
    } else {
      $('#outputCol').removeClass('col-md-6');
    }
    return refresh();
  });
  return $('.alts').click(function() {
    var chord;
    chord = _.unescape($(this).attr('data-chord'));
    $('#alternatesModal .modal-body').html(generateAltsModal(file.alts, chord, state));
    if (_.isNull(state.replacements[chord])) {
      $('#resetChord').addClass('btn-info');
    } else {
      $("#alternatesModal .modal-body [data-index=" + state.replacements[chord] + "]").addClass('btn-info');
    }
    $('#alternatesModal').modal('show');
    return $('#alternatesModal button').click(function() {
      var index;
      chord = $(this).attr('data-chord');
      index = $(this).attr('data-index');
      replacements[chord] = index != null ? index : null;
      state.replacements = replacements;
      $('#alternatesModal').modal('hide');
      return refresh();
    });
  });
};

$(function() {
  var switchHandler;
  $('#input').val(example);
  refresh();
  $('#input').keyup(refresh);
  $('#settings').click(function() {
    return $("[name='toggle-settings']").bootstrapSwitch('toggleState');
  });
  $("[name='toggle-settings']").on('switchChange.bootstrapSwitch', function(event, bool) {
    state.showSettings = !state.showSettings;
    bool = state.showSettings;
    if (bool) {
      return $('#switches').slideDown();
    } else {
      return $('#switches').slideUp();
    }
  });
  $('#transposeUp').click(function() {
    state.requestedKey = s11.note.create($('#currentKey').html()).sharp().clean().name;
    return refresh();
  });
  $('#transposeDown').click(function() {
    state.requestedKey = s11.note.create($('#currentKey').html()).flat().clean().name;
    return refresh();
  });
  $('#transposeReset').click(function() {
    state.requestedKey = null;
    $('#transposeModal').modal('hide');
    return refresh();
  });
  $('#transposeToolbar button').click(function() {
    var clickedChord;
    clickedChord = $(this).attr('data-transposeChord');
    state.requestedKey = clickedChord;
    $('#transposeModal').modal('hide');
    return refresh();
  });
  switchHandler = function(attr) {
    return function(event, bool) {
      state[attr] = bool;
      return refresh();
    };
  };
  $("[name='toggle-chords']").on('switchChange.bootstrapSwitch', switchHandler('showChords'));
  $("[name='toggle-lyrics']").on('switchChange.bootstrapSwitch', switchHandler('showLyrics'));
  $("[name='toggle-muted']").on('switchChange.bootstrapSwitch', switchHandler('smartMode'));
  $("[name='toggle-section']").on('switchChange.bootstrapSwitch', switchHandler('showSections'));
  $("[name='toggle-alts']").on('switchChange.bootstrapSwitch', switchHandler('showAlts'));
  return $("input.bs").bootstrapSwitch();
});

generateAltsModal = function(alts, chord, state) {
  var fstring, i, index, len, printChord, ref, rep;
  printChord = chord.replace(/'/g, '');
  printChord = transpose(state.originalKey, state.drawKey, printChord);
  fstring = '';
  fstring += "    <button type='button' class='btn btn-lg btn-link' disabled='disabled'>Replace</button>";
  fstring += "    <button type='button' class='btn btn-lg btn-default' id='resetChord' data-chord='" + (_.escape(chord)) + "'>" + printChord + "</button>";
  fstring += "    <button type='button' class='btn btn-lg btn-link' disabled='disabled'>with</button>";
  ref = alts[chord];
  for (index = i = 0, len = ref.length; i < len; index = ++i) {
    rep = ref[index];
    fstring += "  <button type='button' class='btn btn-lg btn-default' data-chord='" + (_.escape(chord)) + "' data-index='" + index + "'>" + (transpose(state.originalKey, state.drawKey, rep)) + "</button>";
  }
  return fstring;
};
