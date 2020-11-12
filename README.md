# FlappingHead
FlappingHead is a voice-activated talking-head program. The program can pick up any mic's current audio and move a mouth (and move the head if there's enough volume coming through) to suit it. At the current stage of development the program is fairly customizeable in that you can use most any art assets to replace the defaults, regardless of size (so long as they fit on the screen). The program has a standard green-screen backdrop for ease of use as an overlay on streams.


![Default Skin](https://i.imgur.com/FsbxwdA.gif) 

## Post-Processing Shaders
![Shaders](https://i.gyazo.com/c040308c1e2e7ca7b0cc67c6acd3dd16.png)

### Latest Releases:
https://github.com/Kanium/flappinghead/releases

## Compiling
The program is built with Love2D
You only need to mess with Love2D if you feel like compiling this code, or tweaking it yourself, for a guide on how to use it: https://love2d.org/wiki/Game_Distribution


## Audio Controls
"P" = Toggle Recording

"=" = preAmp +

"-" = preAmp -

"[" = Quality -

"]" = Quality +

"Num +" = Noisegate +

"Num -" = Noisegate -

"9" = NoiseCap -

"0" = NoiseCap +

"'" = Next Prop

";" = Last Prop

"/" = Toggle Prop (if enabled in config.lua)

"D" = Switch Recording Device

"H" = Hide or Show Info-Text

## Facial Controls
Arrow Keys

*Faces work more like a gear shifter, see diagram below:*


                          Happier
				|
				|
				|
				|
		Scared-er-------Neutral-------Angrier
				|
				|
				|
				|
			       Sadder
			       
New Mood reset Key shifts to Neutral from any position. Default binding is "R"			      

## Custom Assets
Replace the files in the "Custom" folder with your own graphics. Make sure all parts have the same canvas size (as eachother, not necessarily the same as the originals) so that when overlayed they will be in the appropriate positions.

You must match the filenames of the originals or the filenames for the extra parts listed int he config.lua file exactly, capitalization matters.

Do not delete any of the original files (excepting Nose and Hair). If you need a layer not to show up, simply make an empty transparent png with the same name.

#### Props
The Props folder is for any props you want to overlay on top of everything. They will still bobble with the head. Make sure to enableProps in the config.lua and don't forget to toggle the prop on as well with hotkeys.

### Configuration
https://github.com/Kanium/flappinghead/wiki/Configuration

### Settings Explanations
https://github.com/Kanium/flappinghead/wiki/Audio-Settings

### On Using the Program in the background
This is a pastebin to the script I use for controlling the window without bringing it to the front.
https://pastebin.com/1s30q2Ss
Look into AutoHotKey if this is a solution you'd like to implement.

### On Animating a second Face for discord buddy
This walkthrough is too long to post here, but I've created a handy guide with pictures and such here:
https://www.mediafire.com/file/gjhrhpwlyduursd/Discordflappinghead.pdf/file
