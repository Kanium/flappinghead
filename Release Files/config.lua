--Determines how much the head bobbles as you talk (Higher is more, recommended 0.01-0.1 at max)
bobbleConstant = 0.02
-- Open the openmouth.png in an image editor and find the X and Y pixes when your mouse is on the center of the mouth.
mouthXOff = 158
mouthYOff = 395
-- Set defaults for Audio Setup
noisegate = 0
noisecap = 20
preAmp = 200
quality = 100
-- Key Bindings
-- For a list of "names" for the keys see: https://love2d.org/wiki/KeyConstant
-- Key Bindings must be in quotation marks
toggleMicKey = "p"
changeMicKey = "d"
moodUpKey = "up"
moodDownKey = "down"
moodRightKey = "right"
moodLeftKey = "left"
nextPropKey = "'"
lastPropKey = ";"
togglePropKey = "/"
preAmpDownKey = "-"
preAmpUpKey = "="
qualityDownKey = "["
qualityUpKey = "]"
noiseGateUpKey = "kp+"
noiseGateDownKey = "kp-"
noiseMaxUpKey = "0"
noiseMaxDownKey = "9"
hideUIKey = "h"

-- Background Color 0-255 RGB and Alpha
bgRed = 0
bgGreen = 255
bgBlue = 0
bgBrightness = 255

-- Change Filter Mode for scaling 
--("nearest" is default, but for smoother scaling you can use "linear")
filterMode = "nearest"
anistropy = 0

--Face Basics
enableNose = true
enableHair = true

--Face Extras
enableangryEyes2 = false
enableangryMouth2 = false
enablehappyEyes2 = false
enablehappyMouth2 = false
enablesadEyes2 = false
enablesadMouth2 = false
enablescaredEyes2 = false
enablescaredMouth2 = false

--Mouth Extras
enableopenangryMouth = false
enableopenhappyMouth = false
enableopenscaredMouth = false
enableopensadMouth = false

--Prop Extras
enableProp = false