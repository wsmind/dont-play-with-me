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
	
	self.color = self.mood:getColorVec4()
	self.pulseDuration = 2
	self.pulseBreakDuration = 1
	
	self.currentTime = 0
	self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	
	self.nextBreakTime = 5
	
	self.image = love.graphics.newImage("assets/background/Gradient.png")
	self.imageScaleY = love.graphics.getHeight() / self.image:getHeight()
	self.imageScaleX = love.graphics.getWidth() / self.image:getWidth()
	
    return self
end

function Background:update(dt)
	self.currentTime = self.currentTime + dt * (1 + self.mood.excitement)
	
	-- updates the pulse parameters according to mood.
	self.pulseBreakDuration = 2 --* (1 - self.mood.excitement) + 0.5
	
	-- pulses the background color
	local baseColor = self.mood:getColorVec4()
	local shift = math.sin(self.currentTime * Config.bgPulseColorSpeed) * Config.bgPulseColorAmplitude -- gets the color shift
	baseColor = (baseColor + vec4(shift, shift, shift, shift)):clamp(0, 255) -- shiffted color
	local finalFactorFirstBeat = math.exp(-math.fmod(self.currentTime, self.pulseDuration) * 0.9) -- break and shift factor
	local finalFactorSecondBeat = math.exp(-math.fmod(self.currentTime - 0.5, self.pulseDuration) * 0.8) * 0.8 -- break and shift factor
	baseColor = baseColor * (finalFactorFirstBeat + finalFactorSecondBeat) -- shiffted color + breaks
	self.color = baseColor:clamp(0, 255)
end

function Background:draw()
	-- set color
	love.graphics.setColor(self.color:asTable())
	
	-- set color mode
	love.graphics.setColorMode("modulate")
	
	-- draw
	love.graphics.draw(self.image, 0, 0, 0, self.imageScaleX, self.imageScaleY)
end