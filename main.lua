function love.load()
	-- Setup the window
	love.window.setTitle( "FlappingHead" )
	love.window.setMode( 400, 400, {resizable=true, vsync=false, minwidth=400, minheight=400} )
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
	-- set the noise gate (Higher means it ignores lower sounds)
	noisegate = 0
	preAmp = 300
	quality = 100
	-- loading our images into the code
	face = love.graphics.newImage("face.png")
	nose = love.graphics.newImage("nose.png")
	hair = love.graphics.newImage("hair.png")
	openmouth = love.graphics.newImage("openmouth.png")
	--Different facial expressions here
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
	-- will we be using a hinge mouth?
	hinge = 0
	mood = "neutral"
end

function love.update(dt)
	-- dt is the time passed since update was last called
	-- This allows us to have a "tick" every 1 second, rather than trying to do our code as fast as possible.
	t = t + dt
	-- When tick is over 1, you have to subtract by 1, not re-set to 0 so you can account for any dt past the 1 second mark (those miliseconds add up, and ruin FPS calculations if you forget them)
	if t >= 1 then
		t = t-1
		-- Get the Mic's Sample Rate; Mainly for debugging
		sample = Mic:getSampleRate()
	end
end

function love.draw()
	-- Some debug values so you can see when the Mic is on etc.
	love.graphics.print("Rec: " ..tostring(Mic:isRecording()),0,0)
	love.graphics.print(tostring(Mic:getName()),70,0)
	love.graphics.print("Quality: " ..tostring(quality) ..", Amplification: " ..tostring(preAmp) .."%, Noisegate: " ..tostring(noisegate),10,10)
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
	love.graphics.draw(face, 20, 20)
	love.graphics.draw(hair, 20, 20)
	love.graphics.draw(nose, 20, 20)
	
	-- **deprecated** Why re-code it everytime? set at the top whether you want a hinge-mouth or not.
	--[[if hinge == 1 then
	-- define the center hingepoint, in pixels, of your image (easy as opening it in paint as seeing the co-ordinates on-screen.)
		local xoff = 370
		local yoff = 300
		-- The volume number can go ridiculously high, so we have to set a visual cap that keeps the actor's head from launching off into space. Depending on microphones, 10-20 seems to be a good cutoff.
		if volume <= 10 then
		-- this is a long function, so I'll summarize: draw(<image>,<x>,<y>,<Rotation in radians>,<scaleX>,<scaleY>,<xOffset>,<yOffset>)
			love.graphics.draw(bottom, 20+(xoff),20+(yoff),(volume/10)*0.25,1,1,xoff,yoff)
		else
			love.graphics.draw(bottom, 20+(xoff),20+(yoff),0.25,1,1,xoff,yoff)
		end
	else--]]
		-- find the offsets by moving your mouse over the center of the mouth, and seeing the x and y coordinates in pixels.
		mouthXOff = 73
		mouthYOff = 149
		if volume == 0 then
			if mood == "neutral" then
				love.graphics.draw(neutralMouth,20,20)
			elseif mood == "happy" then
				love.graphics.draw(happyMouth,20,20)
			elseif mood == "sad" then
				love.graphics.draw(sadMouth,20,20)
			elseif mood == "scared" then
				love.graphics.draw(scaredMouth,20,20)
			elseif mood == "angry" then
				love.graphics.draw(angryMouth,20,20)
			end
		elseif volume <= 10 then
			love.graphics.draw(openmouth, 20+mouthXOff, 20+mouthYOff, 0, 1, volume/5, 75, 150)
		else
			love.graphics.draw(openmouth, 20+mouthXOff, 20+mouthYOff, 0, 1, 2, 75, 150)
		end
	-- another debug value: simply prints the current volume level so you can see how high it goes.
	love.graphics.print("avg sound: " ..tostring(volume),0,20)
	if mood == "neutral" then
		love.graphics.draw(neutralEyes,20,20)
	elseif mood == "happy" then
		love.graphics.draw(happyEyes,20,20)
	elseif mood == "sad" then
		love.graphics.draw(sadEyes,20,20)
	elseif mood == "scared" then
		love.graphics.draw(scaredEyes,20,20)
	elseif mood == "angry" then
		love.graphics.draw(angryEyes,20,20)
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
end