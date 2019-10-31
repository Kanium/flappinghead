

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
	noisegate = 0
	preAmp = 300
	quality = 100
	mood = "neutral"
	hidden = 0
	rotation = 0
	tick = 0
	bobbleConstant = 0.02
	
	-- Setting RootDirectory
	rootDir = love.filesystem.getSourceBaseDirectory()
	success = love.filesystem.mount(rootDir, "Root")

	-- find the offsets by moving your mouse over the center of the mouth, and seeing the x and y coordinates in pixels.
	mouthXOff = 73
	mouthYOff = 149


	-- Only check for custom assets if release build
	if love.filesystem.isFused( ) then
		loaded = 0
		--load config
		chunk = love.filesystem.load("Root/config.lua")
		chunk()
	else
		loaded = 1
	end
		
	
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
	
	--Set Dimensions of window to the image
	local wid,hig = face:getDimensions()
	startHeight = hig
	love.window.setMode(wid,hig,{resizable=true, vsync=false, minwidth=200, minheight=200})
end


function love.resize(w,h)
	yScale = h/startHeight
	xScale = (yScale/26)*25
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
	if tick > 40 then
		tick = 1
		if volume >= 10 and volume < 20 then
			rotation = rotation + (math.random(-1,1)/100)
			if rotation > bobbleConstant then
				rotation = bobbleConstant
			end
			if rotation < -bobbleConstant then
				rotation = -bobbleConstant
			end
		end
		--Double the bobble when louder.
		if volume >= 20 then
			rotation = rotation + (math.random(-10,10)/100)
			if rotation > (bobbleConstant*2) then
				rotation = (bobbleConstant*2)
			end
			if rotation < -(bobbleConstant*2) then
				rotation = -(bobbleConstant*2)
			end
		end
		-- slowly reset head to default position when not talking.
		if volume == 0 then
			if rotation > 0 then
				rotation = rotation - 0.01
			end
			if rotation < 0 then
				rotation = rotation + 0.01
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
		if volume <= 0 then 
			volume = 0 
		end
	end	
	
	-- Make sure to layer your pieces properly, Bottom layer first.
	love.graphics.draw(face, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	love.graphics.draw(hair, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	love.graphics.draw(nose, 0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	-- Draw a mouth based on mood variable
		if volume == 0 then
			if mood == "neutral" then
				love.graphics.draw(neutralMouth,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
			elseif mood == "happy" then
				love.graphics.draw(happyMouth,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
			elseif mood == "sad" then
				love.graphics.draw(sadMouth,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
			elseif mood == "scared" then
				love.graphics.draw(scaredMouth,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
			elseif mood == "angry" then
				love.graphics.draw(angryMouth,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
			end
		-- swap it for an open one when talking, and scale based on the loudness.
		elseif volume <= 20 then
			love.graphics.draw(openmouth, 0+mouthXOff*xScale, 0+mouthYOff*yScale, rotation, (xScale * 1), (yScale * (volume/8)), mouthXOff, mouthYOff)
		else
			love.graphics.draw(openmouth, 0+mouthXOff*xScale, 0+mouthYOff*yScale, rotation, (xScale * 0.85), (yScale * 2), mouthXOff, mouthYOff)
		end
	
	if mood == "neutral" then
		love.graphics.draw(neutralEyes,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	elseif mood == "happy" then
		love.graphics.draw(happyEyes,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	elseif mood == "sad" then
		love.graphics.draw(sadEyes,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	elseif mood == "scared" then
		love.graphics.draw(scaredEyes,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	elseif mood == "angry" then
		love.graphics.draw(angryEyes,0+mouthXOff*xScale, 0+mouthYOff*yScale,rotation,xScale,yScale, mouthXOff, mouthYOff)
	end
	
	if hidden == 0 then
		-- another debug value: simply prints the current volume level so you can see how high it goes.
		love.graphics.setColor(0,0,0,1)
		love.graphics.print("Vol:" ..tostring(volume),0,26,0)
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
			love.graphics.rectangle("fill",40,28,volume*5,10)
		else
			love.graphics.rectangle("fill",40,28,100,10)
		end
		love.graphics.setColor(1,1,1,1)
	end
end

function love.keypressed(key)
	-- Start and stop the microphone. In theory the values in start() setup the microphone's samplerate etc. But I cannot be certain it works at all.
	if key == "s" then
		Mic:start(7680, 7680, 16, 1)
		recording = 1
	end
	if key == "p" then
		recording = 0
		Mic:stop()
	end
	-- Mood toggling
	if key == "up" then
		if mood == "sad" then
			mood = "neutral"
		else
			mood = "happy"
		end
	end
	if key == "down" then
		if mood == "happy" then
			mood = "neutral"
		else
			mood = "sad"
		end
	end
	if key == "right" then
		if mood == "scared" then
			mood = "neutral"
		else
			mood = "angry"
		end
	end
	if key == "left" then
		if mood == "angry" then
			mood = "neutral"
		else
			mood = "scared"
		end
	end
	if key == "-" then
		if preAmp >= 10 then
			preAmp = preAmp - 10
		end
	end
	if key == "=" then
		if preAmp < 1000 then
			preAmp = preAmp + 10
		end
	end
	if key == "[" then
		if quality >= 20 then
			quality = quality - 10
		end
	end
	if key == "]" then
		if quality < 500 then
			quality = quality + 10
		end
	end
	if key == "kp+" then
		if noisegate < 50 then
			noisegate = noisegate + 1
		end
	end
	if key == "kp-" then
		if noisegate >= 1 then
			noisegate = noisegate - 1
		end
	end
	if key == "d" then
		if device < #devices then
			device = device + 1
		else
			device = 1
		end
		Mic=devices[device]
	end
	if key == "h" then
		if hidden == 0 then
			hidden = 1
		else
			hidden = 0
		end
	end
end