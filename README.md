# markato
A readable markup language for lyrics and chords

## Examples

The first Markato file ever written, and our first demo, is of the song _I Wanna Hold Your Hand_ by *The Beatles*.
 - [i-wanna-hold-your-hand.mko](https://github.com/jsrmath/markato/blob/master/i-wanna-hold-your-hand.mko)

## Overview
Web resources for finding and creating chord charts are few and far between. The most common source is the plain monospaced text file, which uses manual alignment to position chords over lyrics. These files are easy to write, but once published on a lyrics / chords site, difficult to edit. As a result, multiple versions of a song often float around, arbitrarily ranked.

### Philosophy
We envision a single, unifying data format for creating and editing chord charts. Like [Markdown](https://daringfireball.net/projects/markdown), Markato aims to be publishable as-is, as plain text, with human-readable syntax. Similarly, like the [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki) publishing engine, the layperson should be able to edit a chart, immediately understand the syntax, and make the required changes without facing compilation errors, let alone the idea of compilation.

## Core Mechanics
The essential concept in Markato is the idea of attaching a chord to a word. Instead of delineating Markato with rhythmic notation, which is often obtuse or complicated, Markato anchors chords to words and the spaces between them. 

### Lyrics and Chords
For example, here is a typical lyric, marked up in Markato.
```
:       G              D          Em               E7    Bm
Oh yeah ^I’ll tell you ^something ^ I think you’ll ^under^stand
:    G           D           Em                     B7
When ^I say that ^something, ^ I want to hold your h^and!
```

A line containing chords must begin with a colon (`:`). To denote the positions of chords in a line, we use the carrot (`^`) character. Markato looks at the number of carrots and chords and matches them appropriately.

#### Whitespace in Chord Lines
Whitespace in chord lines doesn't matter; the above lyric could easily be written:
```
: G D Em E7 Bm
Oh yeah ^I'll tell you ^something ^ I think you'll ^under^stand
```
As a result, chords must not contain spaces.

#### Attaching Chords
A chord can be attached to a word in a few ways. If the chord and the word coincide, it makes sense to write the carrot immediately before the word, with no space. A Markato visualization engine might choose to print the chord directly above the word in question.
```
:               D
When I say that ^something,
```
Chords may often come in the middle of words,
```
:                   Bm
I think you'll under^stand
```
or in the beats between words.
```
:                          Em
When I say that something, ^ I wanna hold your hand!
```
Markato knows what each of these means and parses it accordingly.

## Sections
Sections of a song (such as Intro, Verse, Chorus, Bridge, etc.) are prefaced with a single pound `#` sign, like titles in Markdown. 

### Section Naming
Anything can be a section name. Because of the wide range of keywords (intro, verse, chorus, bridge, prechorus, coda, outro, etc.) and languages Markato aims to support, we treat all lines beginning with the pound sign as section declarations.

### Inferred Chords
Critically, explicitly denoting the form of a song allows the user to neglect writing the chord the second time.

Here is an example of an inferred chord.
```
#CHORUS
:C         D          G  Em  
 ^ I wanna ^hold your ^ha^nd!
:C         D          G      
 ^ I wanna ^hold your ^hand!

#CHORUS
^Now let me ^hold your ^ha^nd
^ I wanna ^hold your ^hand

```
By denoting each chorus explicitly, the user merely needs to note the chord positions; the chords cascade between similar secitions automatically.

### Exceptions
Often a chorus will be the same upon second iteration, except for a key difference. Markato supports this, with the wildcard (*) character.
```
#CHORUS
:C         D          G  Em  
 ^ I wanna ^hold your ^ha^nd!
:C         D          G      
 ^ I wanna ^hold your ^hand!

#CHORUS
^Now let me ^hold your ^ha^nd
:*         Dmaj7      *
 ^ I wanna ^hold your ^hand
```
Markato also knows what this means.

## Alternate Chords
Markato seeks to solve the issue of competing interpretations. When a user disagrees with the present form of a chord, they may use a footnote symbol `'` to add a footnote, which offers a substitution or list of substitutions for that chord. This may be interpreted in a number of ways by a Markato visualization engine.

Alternate Chords are written at the end of a song, after a triple pound character `###`. If there are two conflicts on the same base token, a double or even triple footnote can be used. Here is an example:
```
:E'            C     E''    Am
 ^ It's been a ^hard ^day's ^night

###
E'  => Bm7#11, Bmaj7
E'' => Bmin7, Bb9
```

