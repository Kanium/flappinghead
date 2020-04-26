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
noisecap = 20
preAmp = 200
quality = 50
mood = "neutral"
hidden = 0
micControlColor = {1,1,1,1}

--0.01-0.1 are "normal" values higher = more extreme
bobbleConstant = 0.02

--Default Keybinds
toggleMicKey = "p"
changeMicKey = "d"
preAmpDownKey = "-"
preAmpUpKey = "="
qualityDownKey = "["
qualityUpKey = "]"
noiseGateUpKey = "kp+"
noiseGateDownKey = "kp-"
hideUIKey = "h"
noiseMaxUpKey = "0"
noiseMaxDownKey = "9"

function getSample()
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
end

function drawMicControls()
	if hidden == 0 then
		-- another debug value: simply prints the current volume level so you can see how high it goes.
		love.graphics.setColor(micControlColor)
		love.graphics.print("Vol:" ..tostring(rawvolume),0,26,0)
		love.graphics.setColor(micControlColor)
		-- Some debug values so you can see when the Mic is on etc.
		love.graphics.print("Rec:" ..tostring(Mic:isRecording()),0,0,0)
		love.graphics.print(tostring(Mic:getName()),60,0,0,0.8,0.8)
		love.graphics.print("Ql:" ..tostring(quality) .." Amp:" ..tostring(preAmp) .."% NGate:" ..tostring(noisegate),00,13,0)
		love.graphics.setColor(0.2,0.2,0.2,1)
		love.graphics.rectangle("fill",40,28,100,10)
		if volume >= noisecap * 0.75 then
			love.graphics.setColor(1,0.7,0.3,1)
		end
		if volume >= noisecap then
			love.graphics.setColor(1,0.2,0.2,1)
		end
		if volume < noisecap*0.5 then
			love.graphics.setColor(0.2,1,0.2,1)
		end
		if volume < noisecap then
			love.graphics.rectangle("fill",40,28,rawvolume*5,10)
		else
			love.graphics.rectangle("fill",40,28,100,10)
		end
		love.graphics.setColor(micControlColor)
		love.graphics.line(40+(noisegate*5),28,40+(noisegate*5),38)
		love.graphics.setColor(1,0.2,0.2,1)
		love.graphics.line(40+(noisecap*5),28,40+(noisecap*5),38)
		love.graphics.setColor(1,1,1,1)
	end
end

function micControls(key)
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
	if key == noiseMaxUpKey then
		if noisecap < 100 then
			noisecap = noisecap + 1
		end
	end
	if key == noiseMaxDownKey then
		if noisecap >= 1 then
			noisecap = noisecap - 1
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