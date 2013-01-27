--[[ 

]]

Soundtrack = {}
Soundtrack.__index = Soundtrack

function Soundtrack.new(options)
    local self = {}
    setmetatable(self, Soundtrack)
	
	self.tracks = {
		alpha = love.audio.newSource("assets/music/LukHash - Alpha (mangatome edit).mp3", "static"),
		tonight = love.audio.newSource("assets/music/LukHash - TONIGHT.mp3")
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

function Soundtrack:startAllMute()
	for _, source in pairs(self.tracks) do
		love.audio.play(source)
		source:setVolume(0)
		source:setLooping(true)
	end
end