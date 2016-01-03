// Generated by CoffeeScript 1.10.0
(function() {
  var location;

  location = '#canvas';

  $(function() {
    var state;
    state = {
      showChords: true,
      showRepeats: false,
      smartMode: true
    };
    draw(location, hold, state);
    $('#showChords').change(function() {
      var idd;
      idd = $('#showChords label.active').attr('id');
      state.showChords = idd === 'none' ? false : true;
      state.smartMode = idd === 'smart' ? true : false;
      return draw(location, hold, state);
    });
    $('#showSections').change(function() {
      var idd;
      idd = $('#showSections label.active').attr('id');
      state.showSections = idd === 'on' ? true : false;
      return draw(location, hold, state);
    });
    $('#showChords #smart').click();
    return $('#showSections #on').click();
  });

}).call(this);