function love.load()
	-- Setup the window
	love.window.setTitle( "FlappingKermit" )
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
	noisegate = 10
	preAmp = 200
	quality = 200
	-- loading our images into the code
	k0 = love.graphics.newImage("kermit/0.png")
	k1 = love.graphics.newImage("kermit/1.png")
	k2 = love.graphics.newImage("kermit/2.png")
	k3 = love.graphics.newImage("kermit/3.png")
	k4 = love.graphics.newImage("kermit/4.png")
	k5 = love.graphics.newImage("kermit/5.png")
	k6 = love.graphics.newImage("kermit/6.png")
	k7 = love.graphics.newImage("kermit/7.png")
	k8 = love.graphics.newImage("kermit/8.png")
	k9 = love.graphics.newImage("kermit/9.png")
	k10 = love.graphics.newImage("kermit/10.png")
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
	
	if recording == 0 then
		love.graphics.draw(k0, 30, 40,0,2,2)
	end
	
	if volume == 0 then
		love.graphics.draw(k0, 30,40,0,2,2)
	elseif volume == 1 then
		love.graphics.draw(k1, 30,40,0,2,2)
	elseif volume == 2 then
		love.graphics.draw(k2, 30,40,0,2,2)
	elseif volume == 3 then
		love.graphics.draw(k3, 30,40,0,2,2)
	elseif volume == 4 then
		love.graphics.draw(k4, 30,40,0,2,2)
	elseif volume == 5 then
		love.graphics.draw(k5, 30,40,0,2,2)
	elseif volume == 6 then
		love.graphics.draw(k6, 30,40,0,2,2)
	elseif volume == 7 then
		love.graphics.draw(k7, 30,40,0,2,2)
	elseif volume == 8 then
		love.graphics.draw(k8, 30,40,0,2,2)
	elseif volume == 9 then
		love.graphics.draw(k9, 30,40,0,2,2)
	elseif volume >= 10 then
		love.graphics.draw(k10, 30,40,0,2,2)
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