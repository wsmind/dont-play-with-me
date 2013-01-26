--[[ 

]]

require("math.vec4")
require("game.Config")

Background = {}
Background.__index = Background

function Background.new(options)
    local self = {}
    setmetatable(self, Background)
	
	self.mood = options.mood
	
	self.color = self.mood:getColorVec4():asTable()
	self.pulseDuration = 2
	self.pulseBreakDuration = 5
	
	self.currentTime = 0
	self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	
	self.nextBreakTime = 5
	
    return self
end

function Background:update(dt)
	self.currentTime = self.currentTime + dt
	
	-- updates the pulse parameters according to mood.
	self.pulseBreakDuration = 5 * (1 - self.mood.excitement) + 0.5
	
	-- pulses the background color
	local baseColor = self.mood:getColorVec4()
	local shift = math.sin(self.currentTime * Config.bgPulseColorSpeed) * Config.bgPulseColorAmplitude -- gets the color shift
	baseColor = (baseColor + vec4(shift, shift, shift, shift)):clamp(0, 255) -- shiffted color
	baseColor = baseColor * math.exp(-math.fmod(self.currentTime, self.pulseBreakDuration)) * self.pulseDuration -- shiffted color + breaks
	self.color = baseColor:asTable()
end

function Background:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, Config.virtualScreenHeight * self.screenRatio, Config.virtualScreenHeight)
end