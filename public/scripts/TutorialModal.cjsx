React = require 'react'
Modal = require 'react-bootstrap-modal'
classNames = require 'classnames'

module.exports = React.createClass
  tutorial: ->
    <div>
      <p><strong>Lyrics and Chords</strong></p>
      <p>
        There are two types of lines in Markato: lyric lines and chord lines.
        The chords for a particular lyric line go above the lyric line.
        Chord lines begin with a <code>:</code> and list the chords separated by spaces.
        Lyric lines contain text with <code>^</code>s to indicate where the corresponding chords fall in the lyrics.
        Markato will automatically format the chords based on the <code>^</code> placement so that they line up.
        Chords can go at the beginning of a word, in the middle of a word, or before or between words.  For example:
      </p>
      <p>
        <pre>
          :C D G Em 
          ^ I wanna ^hold your ^ha^nd
        </pre>
      </p>
      <p><strong>Sections</strong></p>
      <p>
        Markato lets you define sections of your song using <code>#</code>.
        Section names are not predefined and can be whatever you want.
        In this example, let's define a section called <code>CHORUS</code>:
      </p>
      <p>
        <pre>
          #CHORUS
          :C D G Em 
          ^ I wanna ^hold your ^ha^nd
          :C D G
          ^ I wanna ^hold your ^hand
        </pre>
      </p>
      <p>
        Now, you can repeat the entire chorus just by typing <code>#CHORUS</code> again.
        If you want to repeat a section with the same chords and different lyrics, just write the new lyrics with the appropriate <code>^</code>s and Markato will render the chords automatically.
      </p>
      <p>
        <pre>
          #VERSE
          :G D
          Oh yeah, ^I'll tell you ^something
          :Em Bm
          ^ I think you'll under^stand
          :G D
          When ^I'll say that ^something
          :Em B
          ^ I wanna hold your h^and

          #VERSE
          Oh ^please, say to ^me
          ^ You'll let me be your ^man
          And ^please, say to ^me
          ^ You'll let me hold your h^and
        </pre>
      </p>
      <p>
        You can also repeat some parts of a previous section but substitute others.
        Just redefine what you want to be different and everything else will be the same.
        If you want to reuse some but not all chords in a particular line, use <code>*</code>.
      </p>
      <p>
        <pre>
          #CHORUS
          ^ I wanna ^hold your ^ha^nd
          :* * B
          ^ I wanna ^hold your ^hand
          :C D C G
          ^I wanna ^hold your ^ha-a-^and
        </pre>
      </p>
      <p><strong>Playback</strong></p>
      <p>
        When you are in playback mode, you will see a green box around the current chord.
        Pressing spacebar will play the current chord.
        Use the left and right arrow keys to navigate between chords or click a chord to jump to it.
        Markato makes it easy to play through your song the way you would on a piano or a guitar.
      </p>
      <p><strong>Metadata</strong></p>
      <p>
        Metadata about your song like the title, artist, album, and key can be defined using <code>##</code>.
        For example:
      </p>
      <p>
        <pre>
          ##TITLE  I Wanna Hold Your Hand
          ##ARTIST The Beatles
          ##ALBUM  A Hard Day's Night
          ##KEY    G
        </pre>
      </p>
      <p>
        You can declare any metadata that you'd like, but <code>TITLE</code>, <code>ARTIST</code>, <code>ALBUM</code>, and <code>KEY</code> are the only ones that will be displayed.
      </p>
    </div> 

  render: ->
    classes = classNames ['tutorial-modal', 'modal-visible': @props.show]
    <Modal show={@props.show}
           onHide={@props.onHide}
           aria-labelledby="ModalHeader"
           className={classes}
    >
      <Modal.Header>
        <Modal.Title>Markato Tutorial</Modal.Title>
      </Modal.Header>
      <Modal.Body className="btn-toolbar">
        {@tutorial()}
      </Modal.Body>
      <Modal.Footer>
        <Modal.Dismiss className="btn btn-default">Done</Modal.Dismiss>
      </Modal.Footer>
    </Modal>