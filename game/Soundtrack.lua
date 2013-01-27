--[[ 

]]

Soundtrack = {}
Soundtrack.__index = Soundtrack

function Soundtrack.new(options)
    local self = {}
    setmetatable(self, Soundtrack)
	
	self.tracks = {
		--alpha = love.audio.newSource("assets/music/LukHash - Alpha (mangatome edit).mp3", "static"),
		--tonight = love.audio.newSource("assets/music/LukHash - TONIGHT.mp3", "static"),
		--calm = love.audio.newSource("assets/music/LukHash - TONIGHT (calm edit).mp3", "static"),
		--excite = love.audio.newSource("assets/music/LukHash - TONIGHT (excite edit).mp3", "static"),
	}
	
	self.tracks2 = {
		piano = {
			source = love.audio.newSource("assets/music/dynamic_piano.ogg", "static"),
			start = 0
		},
		strings = {
			source = love.audio.newSource("assets/music/dynamic_strings.ogg", "static"),
			start = 0.2
		},
		cello = {
			source = love.audio.newSource("assets/music/dynamic_cello.ogg", "static"),
			start = 0.4
		},
		drums = {
			source = love.audio.newSource("assets/music/dynamic_drums.ogg", "static"),
			start = 0.6
		},
		bass = {
			source = love.audio.newSource("assets/music/dynamic_bass.ogg", "static"),
			start = 0.8
		}
	}
	
	self.crossfadeTracks = nil
	
	self:startAllMute()
	
    return self
end

function Soundtrack:playOnly(trackName)
	-- Mutes all tracks except the target one.
	for track, source in pairs(self.tracks) do
		if trackName == track then
			-- play
			source:setVolume(1)
		else
			-- mute
			source:setVolume(0)
		end
	end
	
end

function Soundtrack:prepareCrossfade(trackNameA, trackNameB)
	-- stops current sounds
	if not (self.crossfadeTracks == nil) then
		self.crossfadeTracks.trackA:stop()
		self.crossfadeTracks.trackB:stop()
	end
	
	-- starts sounds
	local ta = self.tracks[trackNameA]
	local tb = self.tracks[trackNameB]
	self.crossfadeTracks = {
		trackA = ta,
		trackB = tb
	}
	ta:play()
	tb:play()
	ta:setVolume(1)
	tb:setVolume(0)
end

function Soundtrack:updateCrossfade(crossfade)
	if self.crossfadeTracks == nil then
		return
	end
	
	-- updates crossfade volumes
	self.crossfadeTracks.trackA:setVolume(1 - crossfade)
	self.crossfadeTracks.trackB:setVolume(crossfade)
end

function Soundtrack:update(dt, excitement)
	for _, track in pairs(self.tracks2) do
		if excitement >= track.start then
			-- the track should be playing now, fade it up
			local volume = track.source:getVolume()
			volume = volume + dt / Config.soundFadeDuration
			volume = math.min(volume, 1)
			track.source:setVolume(volume)
		else
			-- the track should not be playing now, fade it down
			local volume = track.source:getVolume()
			volume = volume - dt / Config.soundFadeDuration
			volume = math.max(volume, 0)
			track.source:setVolume(volume)
		end
	end
end

function Soundtrack:startAllMute()
	--[[for _, source in pairs(self.tracks) do
		source:setVolume(0)
		source:setLooping(true)
		love.audio.play(source)
	end]]--
	
	for _, track in pairs(self.tracks2) do
		track.source:setVolume(0)
		track.source:setLooping(true)
		love.audio.play(track.source)
	end
end