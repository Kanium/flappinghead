# FlappingHead
FlappingHead is a voice-activated talking-head program. The program can pick up any mic's current audio and move a mouth (and move the head if there's enough volume coming through) to suit it. At the current stage of development the program is fairly customizeable in that you can use most any art assets to replace the defaults, regardless of size (so long as they fit on the screen). The program has a standard green-screen backdrop for ease of use as an overlay on streams.


![Default Skin](https://i.imgur.com/AgXqgmx.gif) 

## Compiling
The program is built with Love2D
You only need to mess with Love2D if you feel like compiling this code, or tweaking it yourself, for a guide on how to use it: https://love2d.org/wiki/Game_Distribution


## Audio Controls
"S" = Start Recording

"P" = Stop Recording (Pause)

"=" = preAmp +

"-" = preAmp -

"[" = Quality -

"]" = Quality +

"Num +" = Noisegate +

"Num -" = Noisegate -

"D" = Toggle Recording Device

"H" = Hide or Show Info-Text


## Facial Controls
Arrow Keys

*Faces work more like a gear shifter, see diagram below:*


                          Happy
				|
				|
				|
				|
		Scared-------Neutral-------Angry
				|
				|
				|
				|
			       Sad

### On Using the Program in the background
This is a pastebin to the script I use for controlling the window without bringing it to the front.
https://pastebin.com/1s30q2Ss
Look into AutoHotKey if this is a solution you'd like to implement.

## Custom Assets
Replace the files in the "Custom" folder with your own graphics. Make sure all parts have the same canvas size (as eachother, not necessarily the same as the originals) so that when overlayed they will be in the appropriate positions.

You must maintain the original filenames exactly, capitalization matters.

Do not delete any of the files. If you need a layer not to show up, simply make an empty transparent png with the same name.
