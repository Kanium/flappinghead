local moonshine = require 'moonshine'

function love.load()
	-- Setup the window
	love.window.setTitle( "FlappingHead" )
	love.window.setMode( 750, 780, {resizable=true, vsync=false, minwidth=200, minheight=200} )
	love.graphics.setBackgroundColor( 0, 255, 0, 255 )
	icon = love.image.newImageData("icon.png")
	love.window.setIcon(icon)
	
	
	--Setup Scaling
	startHeight=780
	xScale = 1
	yScale = 1
	
	-- Populate container with available devices
	devices = love.audio.getRecordingDevices()
	device = 1
	-- Setting Mic as device 1 which is the default recording device on your system
	Mic=devices[device]
	
	-- Setting up some variables for future use
	recording = 0
	t=0
	sample = 0
	volume = 0
	rawvolume = 0
	noisegate = 0
	preAmp = 300
	quality = 100
	mood = "neutral"
	hidden = 0
	rotation = 0
	tick = 0
	--0.01-0.1 are "normal" values higher = more extreme
	bobbleConstant = 0.02
	
	--Default Keybinds
	toggleMicKey = "p"
	changeMicKey = "d"
	moodUpKey = "up"
	moodDownKey = "down"
	moodRightKey = "right"
	moodLeftKey = "left"
	preAmpDownKey = "-"
	preAmpUpKey = "="
	qualityDownKey = "["
	qualityUpKey = "]"
	noiseGateUpKey = "kp+"
	noiseGateDownKey = "kp-"
	hideUIKey = "h"
	
	--Setting the Background Color
	bgRed = 0
	bgGreen = 255
	bgBlue = 0
	bgBrightness = 255
	
	-- Setting RootDirectory
	rootDir = love.filesystem.getSourceBaseDirectory()
	success = love.filesystem.mount(rootDir, "Root")

	-- find the offsets by moving your mouse over the center of the mouth, and seeing the x and y coordinates in pixels.
	mouthXOff = 158
	mouthYOff = 395


	-- Only check for custom assets if release build
	if love.filesystem.isFused( ) then
		loaded = 0
		--load config
		chunk = love.filesystem.load("Root/config.lua")
		chunk()
	else
		loaded = 1
	end
		
	love.graphics.setBackgroundColor( bgRed,bgGreen,bgBlue,bgBrightness )
	
	-- loading our defult images into the code
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
	effect = moonshine(moonshine.effects.filmgrain).chain(moonshine.effects.vignette).chain(moonshine.effects.fog).chain(moonshine.effects.boxblur).chain(moonshine.effects.chromasep).chain(moonshine.effects.colorgradesimple).chain(moonshine.effects.crt).chain(moonshine.effects.desaturate).chain(moonshine.effects.dmg).chain(moonshine.effects.fastgaussianblur).chain(moonshine.effects.gaussianblur).chain(moonshine.effects.glow).chain(moonshine.effects.godsray).chain(moonshine.effects.pixelate).chain(moonshine.effects.posterize).chain(moonshine.effects.scanlines).chain(moonshine.effects.sketch)
	
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
end


function love.update(dt)
	if loaded == 0 then
		if success then
			face = love.graphics.newImage("Root/Custom/face.png")
			nose = love.graphics.newImage("Root/Custom/nose.png")
			hair = love.graphics.newImage("Root/Custom/hair.png")
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
				prop = love.graphics.newImage("Root/Custom/Prop.png")
			end
			
			loaded = 1
		else 
			loaded = 2
		end
		local wid,hig = face:getDimensions()
		startHeight = hig
		love.window.setMode(wid,hig,{resizable=true, vsync=false, minwidth=200, minheight=200})
	end
	
	

	-- dt is the time passed since update was last called
	-- This allows us to have a "tick" every 1 second, rather than trying to do our code as fast as possible.
	t = t + dt
	-- When tick is over 1, you have to subtract by 1, not re-set to 0 so you can account for any dt past the 1 second mark (those miliseconds add up, and ruin FPS calculations if you forget them)
	if t >= 1 then
		t = t-1
		-- Get the Mic's Sample Rate; Mainly for debugging
		sample = Mic:getSampleRate()
	end
	
	-- Set up Bobble Animation to only adjust every 40 ticks so as not to overload the cpu
	tick = tick + 1
	if tick > 20 then
		tick = 1
		if volume >= 10 and volume < 20 then
			rotation = rotation + (math.random(-bobbleConstant*100,bobbleConstant*100)/100)
		end
		--Double the bobble when louder.
		if volume >= 20 then
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
	-- test is going to collect averages from the samples, but must be reset to 0 before doing this
	test = 0
	-- The microphone only stores a small buffer of samples, every time you read the buffer, it empties it, so you need to be sure you're sampleing only when there's samples in the buffer to check
	if Mic:getSampleCount() >= quality then
		-- this is the function that clears the buffer, so you need to make use of that data now, or it'll be lost.
		micdata = Mic:getData()
		for i = 1,quality do
		-- the commented out line below would display a linegraph of the samples, you'd recognize it as audio waves
		--love.graphics.line(0+(i),50,0+(i),50-(math.sqrt(((micdata:getSample(i))*(micdata:getSample(i))))*preAmp))
			-- Collecting the values to average. Since they are on a scale of -1 to 1, you can multiply them by themselves to remove the negative bias (I've also "amplified" them so the value would be in the range of 0-100 not 0-1)
			test = test+((math.sqrt((micdata:getSample(i))*(micdata:getSample(i))))*preAmp)
			
		end
		-- finally our microphone "volume" is the average of the samples
		volume = math.floor((test/quality))-noisegate
		--Raw volume for showing where the noisegate cuts off audio
		rawvolume = math.floor((test/quality))
		if volume <= 0 then 
			volume = 0 
		end
	end	
	effect(function()
		-- Make sure to layer your pieces properly, Bottom layer first.
		love.graphics.draw(face, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		love.graphics.draw(hair, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		love.graphics.draw(nose, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		
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
		elseif volume <= 20 then
			love.graphics.draw(talkMouth, 0+mouthXOff*xScale, 0+mouthYOff*yScale, rotation, (xScale * 1), (yScale * (volume/8)), mouthXOff, mouthYOff)
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
		if enableProp == true then
			love.graphics.draw(prop,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
		end
	end)
	
	if hidden == 0 then
		-- another debug value: simply prints the current volume level so you can see how high it goes.
		love.graphics.setColor(0,0,0,1)
		love.graphics.print("Vol:" ..tostring(rawvolume),0,26,0)
		love.graphics.setColor(1,1,1,1)
		love.graphics.setColor(0,0,0,1)
		-- Some debug values so you can see when the Mic is on etc.
		love.graphics.print("Rec:" ..tostring(Mic:isRecording()),0,0,0)
		love.graphics.print(tostring(Mic:getName()),60,0,0,0.8,0.8)
		love.graphics.print("Ql:" ..tostring(quality) .." Amp:" ..tostring(preAmp) .."% NGate:" ..tostring(noisegate),00,13,0)
		love.graphics.setColor(0.2,0.2,0.2,1)
		love.graphics.rectangle("fill",40,28,100,10)
		if volume >= 15 then
			love.graphics.setColor(1,0.7,0.3,1)
		end
		if volume >= 20 then
			love.graphics.setColor(1,0.2,0.2,1)
		end
		if volume < 10 then
			love.graphics.setColor(0.2,1,0.2,1)
		end
		if volume < 20 then
			love.graphics.rectangle("fill",40,28,rawvolume*5,10)
		else
			love.graphics.rectangle("fill",40,28,100,10)
		end
		love.graphics.setColor(1,1,1,1)
		love.graphics.line(40+(noisegate*5),28,40+(noisegate*5),38)
		love.graphics.setColor(1,1,1,1)
	end
end

function love.keypressed(key)
	-- Start and stop the microphone. In theory the values in start() setup the microphone's samplerate etc. But I cannot be certain it works at all.
	if key == toggleMicKey then
		if recording == 0 then
			Mic:start(7680, 7680, 16, 1)
			recording = 1
		else
			recording = 0
			Mic:stop()
		end
	end
	-- Mood toggling
	if key == moodUpKey then
		if mood == "sad" then
			mood = "neutral"
		elseif mood == "sad2" then
			mood = "neutral"
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
			mood = "neutral"
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
			mood = "neutral"
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
			mood = "neutral"
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
	if key == preAmpDownKey then
		if preAmp >= 10 then
			preAmp = preAmp - 10
		end
	end
	if key == preAmpUpKey then
		if preAmp < 1000 then
			preAmp = preAmp + 10
		end
	end
	if key == qualityDownKey then
		if quality >= 20 then
			quality = quality - 10
		end
	end
	if key == qualityUpKey then
		if quality < 500 then
			quality = quality + 10
		end
	end
	if key == noiseGateUpKey then
		if noisegate < 50 then
			noisegate = noisegate + 1
		end
	end
	if key == noiseGateDownKey then
		if noisegate >= 1 then
			noisegate = noisegate - 1
		end
	end
	if key == changeMicKey then
		if device < #devices then
			device = device + 1
		else
			device = 1
		end
		Mic=devices[device]
	end
	if key == hideUIKey then
		if hidden == 0 then
			hidden = 1
		else
			hidden = 0
		end
	end
end