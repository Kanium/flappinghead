# flappinghead
The game is built with Love2D, for a guide on how to use it: https://love2d.org/wiki/Game_Distribution
Love2D is only ~8MB and can be used from a folder: no need to do a full install in most cases.
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
https://pastebin.com/52uzdnGH
Look into AutoHotKey if this is a solution you'd like to implement.

## Custom Assets
Replace the files in the "Custom" folder with your own graphics. Make sure all parts have the same canvas size (as eachother, not necessarily the same as the originals) so that when overlayed they will be in the appropriate positions.

You must maintain the original filenames exactly, capitalization matters.

Do not delete any of the files. If you need a layer not to show up, simply make an empty transparent png with the same name.
