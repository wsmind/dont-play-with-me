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

function Soundtrack:startAllMute()
	for _, source in pairs(self.tracks) do
		--source:setVolumeLimits(0,1)
		love.audio.play(source)
		source:setVolume(0)
		source:setLooping(true)
	end
end