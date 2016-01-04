// Generated by CoffeeScript 1.10.0
(function() {
  var example, file, location;

  location = '#canvas';

  file = '';

  example = '##TITLE  I Wanna Hold Your Hand\n##ARTIST The Beatles\n##ALBUM A Hard Day\'s Night\n\n#INTRO\n: G D Em Bm\n\n#VERSE\n:       G\'             D          Em               E7    Bm\'\nOh yeah ^I\'ll tell you ^something ^ I think you\'ll ^under^stand\n:    G           D           Em                     B7\nWhen ^I say that ^something, ^ I want to hold your h^and!\n\n#CHORUS\n:C         D          G  Em  \n^ I wanna ^hold your ^ha^nd!\n:C         D          G      \n^ I wanna ^hold your ^hand!\n\n#VERSE\nOh ^please say to ^me, ^ you\'ll let me ^be your ^man\n:  *              G    *                          *\nOh ^please say to ^me, ^ you\'ll let me hold your h^and\n\n#CHORUS\n^Now let me ^hold your ^ha^nd\n^ I wanna ^hold your ^hand\n\n#BRIDGE\n:Dm           G                 C        Am        \n^ And when I ^touch you I feel ^happy in^side\n:Bm\'\'          G                C              D   \n^ It\'s such a ^feeling that my ^love, I can\'t ^hide\n:C         D                                       \n^ I can\'t ^hide\n:C         D                                       \n^ I can\'t ^hide\n\n#VERSE\nYeah-ah ^you, got that ^something ^ I think you\'ll under^stand.\nWhen ^I feel that ^something, ^ I wanna hold your ^hand.\n\n#CHORUS\n^ I wanna ^hold your ^ha^and!\n^ I wanna ^hold your ^hand!\n\n###\nG\' => Gsus4\nBm\'  => Bm7#11, Bmaj7\nBm\'\' => Dm';

  $(function() {
    var refresh, state;
    state = {
      showChords: true,
      showRepeats: false,
      showAlts: true,
      smartMode: true
    };
    refresh = function() {
      file = parser.parseString($('#input').val());
      console.log(file);
      draw(location, file, state);
      return $('.alts a').click(function() {
        var id;
        id = $(this).parent().attr('data-id-from');
        console.log(id);
        console.log($("span[data-id-to='" + id + "']"));
        return $("span[data-id-to='" + id + "']").html($(this).html());
      });
    };
    $('#input').val(example);
    refresh();
    $('#input').keyup(refresh);
    $('#showChords').change(function() {
      var idd;
      idd = $('#showChords label.active').attr('id');
      state.showChords = idd === 'none' ? false : true;
      state.smartMode = idd === 'smart' ? true : false;
      return draw(location, file, state);
    });
    $('#showSections').change(function() {
      var idd;
      idd = $('#showSections label.active').attr('id');
      state.showSections = idd === 'on' ? true : false;
      return draw(location, file, state);
    });
    $('#showAlts').change(function() {
      var idd;
      idd = $('#showAlts label.active').attr('id');
      state.showAlts = idd === 'on' ? true : false;
      return draw(location, file, state);
    });
    $('#showSource').change(function() {
      var idd;
      idd = $('#showSource label.active').attr('id');
      if (idd === 'on') {
        $('#input').parent().show();
        return $('#output').addClass('col-sm-6');
      } else {
        $('#input').parent().hide();
        return $('#output').removeClass('col-sm-6');
      }
    });
    $('#showChords #smart').click();
    $('#showSections #on').click();
    $('#showAlts #on').click();
    $('#showSource #off').click();
    return $('.alts a').click(function() {
      var id;
      id = $(this).parent().attr('data-id-from');
      console.log(id);
      console.log($("span[data-id-to='" + id + "']"));
      return $("span[data-id-to='" + id + "']").html($(this).html());
    });
  });

}).call(this);
