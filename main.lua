local moonshine = require 'moonshine'
require "mic"

function love.load()
	-- Setup the window
	love.window.setTitle( "FlappingHead" )
	love.window.setMode( 750, 780, {resizable=true, vsync=false, minwidth=200, minheight=200} )
	icon = love.image.newImageData("icon.png")
	love.window.setIcon(icon)
	screenHeight = 2000
	screenWidth = 2000
	
	
	--Setup Scaling
	startHeight=780
	xScale = 1
	yScale = 1
	
	--PropList
	props = {}
	propNames = {}
	prop = 1
	propToggle = false
	
	mood = "neutral"
	rotation = 0
	tick = 0
	--0.01-0.1 are "normal" values higher = more extreme
	bobbleConstant = 0.02
	
	--Default Keybinds
	moodUpKey = "up"
	moodDownKey = "down"
	moodRightKey = "right"
	moodLeftKey = "left"
	
	nextPropKey = "'"
	lastPropKey = ";"
	
	togglePropKey = "/"
	
	--Setting the Background Color
	bgRed = 0
	bgGreen = 255
	bgBlue = 0
	bgBrightness = 255
	filterMode = "nearest"
	anistropy = 0
	
	-- Setting RootDirectory
	rootDir = love.filesystem.getSourceBaseDirectory()
	success = love.filesystem.mount(rootDir, "Root")

	-- find the offsets by moving your mouse over the center of the mouth, and seeing the x and y coordinates in pixels.
	mouthXOff = 158
	mouthYOff = 395


	
	
		
	love.graphics.setBackgroundColor( bgRed,bgGreen,bgBlue,bgBrightness )
	love.graphics.setDefaultFilter( filterMode, filterMode, anistropy )
	
	-- loading our defult images into the code
	body = love.graphics.newImage("body.png")
	face = love.graphics.newImage("face.png")
	nose = love.graphics.newImage("nose.png")
	hair = love.graphics.newImage("hair.png")
	openmouth = love.graphics.newImage("openmouth.png")
	neutralMouth = love.graphics.newImage("neutralMouth.png")
	happyMouth = love.graphics.newImage("happyMouth.png")
	sadMouth = love.graphics.newImage("sadMouth.png")
	angryMouth = love.graphics.newImage("angryMouth.png")
	scaredMouth = love.graphics.newImage("scaredMouth.png")
	neutralEyes = love.graphics.newImage("neutralEyes.png")
	happyEyes = love.graphics.newImage("happyEyes.png")
	sadEyes = love.graphics.newImage("sadEyes.png")
	angryEyes = love.graphics.newImage("angryEyes.png")
	scaredEyes = love.graphics.newImage("scaredEyes.png")
	
	
	--default mouths
	staticMouth = neutralMouth
	talkMouth = openmouth
	moodEyes = neutralEyes
	
	--Set Dimensions of window to the image
	local wid,hig = face:getDimensions()
	startHeight = hig
	love.window.setMode(wid,hig,{resizable=true, vsync=false, minwidth=200, minheight=200})
	
	
	--Shaders
	effect = moonshine(2000,2000, moonshine.effects.filmgrain).chain(moonshine.effects.vignette).chain(moonshine.effects.fog).chain(moonshine.effects.boxblur).chain(moonshine.effects.chromasep).chain(moonshine.effects.colorgradesimple).chain(moonshine.effects.crt).chain(moonshine.effects.desaturate).chain(moonshine.effects.dmg).chain(moonshine.effects.fastgaussianblur).chain(moonshine.effects.gaussianblur).chain(moonshine.effects.glow).chain(moonshine.effects.godsray).chain(moonshine.effects.pixelate).chain(moonshine.effects.posterize).chain(moonshine.effects.scanlines).chain(moonshine.effects.sketch)
	
	--Turn off by default
	effect.disable("fog","filmgrain","vignette","boxblur","chromasep","colorgradesimple","crt","desaturate","dmg","fastgaussianblur","gaussianblur","glow","godsray","pixelate","posterize","scanlines","sketch")
	
	--boxblur
	effect.boxblur.radius_x = 3
	effect.boxblur.radius_y = 3
	
	--chromasep
	effect.chromasep.angle = 0
	effect.chromasep.radius = 0
	
	--colorgradesimple
	effect.colorgradesimple.factors = {1,1,1}
	
	--crt
	effect.crt.x = 1.06
	effect.crt.y = 1.065
	effect.crt.scaleFactor = {1,1}
	effect.crt.feather = 0.02
	
	--desaturate
	effect.desaturate.tint = {255,255,255}
	effect.desaturate.strength = 0.5
	
	--dmg
	effect.dmg.palette = "pocket"
	
	--fastgaussianblur
	effect.fastgaussianblur.taps = 7
	effect.fastgaussianblur.offset = 1
	effect.fastgaussianblur.sigma = -1
	
	--filmgrain
	effect.filmgrain.opacity = 0.3
	effect.filmgrain.size = 1
	
	--gaussianblur
	effect.gaussianblur.sigma = 1
	
	--glow
	effect.glow.min_luma = 0.1
	effect.glow.strength = 10
	
	--godsray
	effect.godsray.exposure = 0.5
	effect.godsray.decay = 0.95
	effect.godsray.density = 0.05
	effect.godsray.weight = 0.5
	effect.godsray.light_x = 0.5
	effect.godsray.light_y = 0.5
	effect.godsray.samples = 70
	
	--pixelate
	effect.pixelate.size = {5,5}
	effect.pixelate.feedback = 0
	
	--posterize
	effect.posterize.num_bands = 3
	
	--scanlines
	effect.scanlines.width = 2
	effect.scanlines.phase = 0
	effect.scanlines.thickness = 1
	effect.scanlines.opacity = 1
	effect.scanlines.color = {0,0,0}
	
	--sketch
	effect.sketch.amp = 0.0007
	effect.sketch.center = {0,0}
	
	--vignette
	effect.vignette.radius = 0.8
	effect.vignette.softness = 0.5
	effect.vignette.opacity = 0.5
	effect.vignette.color = {0,0,0}
	
	--fog
	effect.fog.fog_color = {0.35, 0.48, 0.95}
	effect.fog.octaves = 4
	effect.fog.speed = {0.5,0.5}
	
	
	
	-- Only check for custom assets if release build
	if love.filesystem.isFused( ) then
		loaded = 0
		--load config
		chunk = love.filesystem.load("Root/config.lua")
		chunk()
		chunk = love.filesystem.load("Root/shader.lua")
		chunk()
	else
		loaded = 1
	end
end


function love.resize(w,h)
	yScale = h/startHeight
	xScale = (yScale/26)*25
	effect.resize(w, h)
	screenHeight = h
	screenWidth = w
end

function loadProps()
	local dir = "Root/Custom/Props"
	--assuming that our path is full of lovely files (it should at least contain main.lua in this case)
	local files = love.filesystem.getDirectoryItems(dir)
	for k, file in ipairs(files) do
		props[#props+1] = love.graphics.newImage(dir .."/" ..file)
		propNames[#propNames+1] = file
	end
end


function love.update(dt)
	if loaded == 0 then
		if success then
			body = love.graphics.newImage("Root/Custom/body.png")
			face = love.graphics.newImage("Root/Custom/face.png")
			openmouth = love.graphics.newImage("Root/Custom/openmouth.png")
			neutralMouth = love.graphics.newImage("Root/Custom/neutralMouth.png")
			happyMouth = love.graphics.newImage("Root/Custom/happyMouth.png")
			sadMouth = love.graphics.newImage("Root/Custom/sadMouth.png")
			angryMouth = love.graphics.newImage("Root/Custom/angryMouth.png")
			scaredMouth = love.graphics.newImage("Root/Custom/scaredMouth.png")
			neutralEyes = love.graphics.newImage("Root/Custom/neutralEyes.png")
			happyEyes = love.graphics.newImage("Root/Custom/happyEyes.png")
			sadEyes = love.graphics.newImage("Root/Custom/sadEyes.png")
			angryEyes = love.graphics.newImage("Root/Custom/AngryEyes.png")
			scaredEyes = love.graphics.newImage("Root/Custom/scaredEyes.png")
			
			--Basics
			if enableNose == true then
				nose = love.graphics.newImage("Root/Custom/nose.png")
			end
			if enableHair == true then
				hair = love.graphics.newImage("Root/Custom/hair.png")
			end
			
			--Image Extras (Enable them individually in the config file)
			if enableangryEyes2 == true then
				angryEyes2 = love.graphics.newImage("Root/Custom/angryEyes2.png")
			end
			if enableangryMouth2 == true then
				angryMouth2 = love.graphics.newImage("Root/Custom/angryMouth2.png")
			end
			if enablehappyEyes2 == true then
				happyEyes2 = love.graphics.newImage("Root/Custom/happyEyes2.png")
			end
			if enablehappyMouth2 == true then
				happyMouth2 = love.graphics.newImage("Root/Custom/happyMouth2.png")
			end
			if enablesadEyes2 == true then
				sadEyes2 = love.graphics.newImage("Root/Custom/sadEyes2.png")
			end
			if enablesadMouth2 == true then
				sadMouth2 = love.graphics.newImage("Root/Custom/sadMouth2.png")
			end
			if enablescaredEyes2 == true then
				scaredEyes2 = love.graphics.newImage("Root/Custom/scaredEyes2.png")
			end
			if enablescaredMouth2 == true then
				scaredMouth2 = love.graphics.newImage("Root/Custom/scaredMouth2.png")
			end

			--Mouth Extras
			if enableopenangryMouth == true then
				openangryMouth = love.graphics.newImage("Root/Custom/openangryMouth.png")
			end
			if enableopenhappyMouth == true then
				openhappyMouth = love.graphics.newImage("Root/Custom/openhappyMouth.png")
			end
			if enableopenscaredMouth == true then
				openscaredMouth = love.graphics.newImage("Root/Custom/openscaredMouth.png")
			end
			if enableopensadMouth == true then
				opensadMouth = love.graphics.newImage("Root/Custom/opensadMouth.png")
			end
			
			--Prop
			if enableProp == true then
				loadProps()
			end
			loaded = 1
		else 
			loaded = 2
		end
		local wid,hig = face:getDimensions()
		startHeight = hig
		love.window.setMode(wid,hig,{resizable=true, vsync=false, minwidth=200, minheight=200})
	end
	
	-- Set up Bobble Animation to only adjust every 40 ticks so as not to overload the cpu
	tick = tick + 1
	if tick > 20 then
		tick = 0
		if volume >= noisecap/2 and volume < noisecap then
			rotation = rotation + (math.random(-bobbleConstant*100,bobbleConstant*100)/100)
		end
		--Double the bobble when louder.
		if volume >= noisecap then
			rotation = rotation + (math.random(-bobbleConstant*200,bobbleConstant*200)/100)
		end
		-- slowly reset head to default position when not talking.
		if volume == 0 then
			if rotation > 0 then
				rotation = rotation - bobbleConstant
			end
			if rotation < 0 then
				rotation = rotation + bobbleConstant
			end
		end
	end
end

function love.draw()
	if recording == 1 then
		getSample()
	end
	local noisediff = noisecap - noisegate
	
	effect(function()
		-- Make sure to layer your pieces properly, Bottom layer first.
		--Body
		love.graphics.draw(body, 0+mouthXOff*xScale, 0+mouthYOff*yScale,1,xScale,yScale, mouthXOff, mouthYOff)
		--Face
		love.graphics.draw(face, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		--Hair
		if enableHair == true then
			love.graphics.draw(hair, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		end
		--Nose
		if enableNose == true then
			love.graphics.draw(nose, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		end
		
		-- Draw a mouth based on mood variable
		if mood == "neutral" then
			staticMouth = neutralMouth
			talkMouth = openmouth
		elseif mood == "happy" then
			staticMouth = happyMouth
			if enableopenhappyMouth == true then
				talkMouth = openhappyMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "sad" then
			staticMouth = sadMouth
			if enableopensadMouth == true then
				talkMouth = opensadMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "scared" then
			staticMouth = scaredMouth
			if enableopenscaredMouth == true then
				talkMouth = openscaredMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "angry" then
			staticMouth = angryMouth
			if enableopenangryMouth == true then
				talkMouth = openangryMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "happy2" then
			if enablehappyMouth2 == true then
				staticMouth = happyMouth2
			else
				staticMouth = happyMouth
			end
			if enableopenhappyMouth == true then
				talkMouth = openhappyMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "sad2" then
			if enablesadMouth2 == true then
				staticMouth = sadMouth2
			else
				staticMouth = sadMouth
			end
			if enableopensadMouth == true then
				talkMouth = opensadMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "scared2" then
			if enablescaredMouth2 == true then
				staticMouth = scaredMouth2
			else
				staticMouth = scaredMouth
			end
			if enableopenscaredMouth == true then
				talkMouth = openscaredMouth
			else
				talkMouth = openmouth
			end
		elseif mood == "angry2" then
			if enableangryMouth2 == true then
				staticMouth = angryMouth2
			else
				staticMouth = angryMouth
			end
			if enableopenangryMouth == true then
				talkMouth = openangryMouth
			else
				talkMouth = openmouth
			end
		end
		
		if volume == 0 then
			love.graphics.draw(staticMouth,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		-- swap it for an open one when talking, and scale based on the loudness.
		elseif volume <= noisecap then
			love.graphics.draw(talkMouth, 0+mouthXOff*xScale, 0+mouthYOff*yScale, rotation, (xScale * 1), (yScale * (volume/noisediff)*2), mouthXOff, mouthYOff)
		else
			love.graphics.draw(talkMouth, 0+mouthXOff*xScale, 0+mouthYOff*yScale, rotation, (xScale * 0.85), (yScale * 2), mouthXOff, mouthYOff)
		end
		
		if mood == "neutral" then
			moodEyes = neutralEyes
		elseif mood == "happy" then
			moodEyes = happyEyes
		elseif mood == "sad" then
			moodEyes = sadEyes
		elseif mood == "scared" then
			moodEyes = scaredEyes
		elseif mood == "angry" then
			moodEyes = angryEyes
		elseif mood == "happy2" then
			moodEyes = happyEyes2
		elseif mood == "sad2" then
			moodEyes = sadEyes2
		elseif mood == "scared2" then
			moodEyes = scaredEyes2
		elseif mood == "angry2" then
			moodEyes = angryEyes2
		end
			love.graphics.draw(moodEyes,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		
		--Draw Prop over everything else
		if enableProp == true and propToggle == true then
			love.graphics.draw(props[prop],0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		end
	end)
	
	if hidden == 0 then
		drawMicControls()
		if enableProp == true then
			love.graphics.print(propNames[prop], 180, 13)
		end
	end
end

function love.keypressed(key)
	-- Mood toggling
	if key == moodUpKey then
		if mood == "sad" then
			mood = "neutral"
		elseif mood == "sad2" then
			mood = "sad"
		elseif mood == "neutral" then
			mood = "happy"
		elseif mood == "happy" and enablehappyEyes2 == true then
			mood = "happy2"
		elseif mood == "happy2" then
			mood = "happy2"
		else
			mood = "happy"
		end
	end
	if key == moodDownKey then
		if mood == "happy" then
			mood = "neutral"
		elseif mood == "happy2" then
			mood = "happy"
		elseif mood == "neutral" then
			mood = "sad"
		elseif mood == "sad" and enablesadEyes2 == true then
			mood = "sad2"
		elseif mood == "sad2" then
			mood = "sad2"
		else
			mood = "sad"
		end
	end
	if key == moodRightKey then
		if mood == "scared" then
			mood = "neutral"
		elseif mood == "scared2" then
			mood = "scared"
		elseif mood == "neutral" then
			mood = "angry"
		elseif mood == "angry" and enableangryEyes2 == true then
			mood = "angry2"
		elseif mood == "angry2" then
			mood = "angry2"
		else
			mood = "angry"
		end
	end
	if key == moodLeftKey then
		if mood == "angry" then
			mood = "neutral"
		elseif mood == "angry2" then
			mood = "angry"
		elseif mood == "neutral" then
			mood = "scared"
		elseif mood == "scared" and enableangryEyes2 == true then
			mood = "scared2"
		elseif mood == "scared2" then
			mood = "scared2"
		else
			mood = "scared"
		end
	end
	if key == nextPropKey then
		prop = prop + 1
		if prop > #props then
			prop = 1
		end
	end
	if key == lastPropKey then
		prop = prop - 1
		if prop < 1 then
			prop = #props
		end
	end
	if key == togglePropKey then
		if propToggle == true then
			propToggle = false
		else
			propToggle = true
		end
	end
	micControls(key)
end