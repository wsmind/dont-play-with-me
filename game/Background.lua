--[[ 

]]

require("math.vec4")

Background = {}
Background.__index = Background

function Background.new(options)
    local self = {}
    setmetatable(self, Background)
	
	self.mood = options.mood
	
	self.color = self.mood:getColorVec4():asTable()
	self.colorPulseMaxShift = 100
	
	self.currentTime = 0
	self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	
    return self
end

function Background:update(dt)
	self.currentTime = self.currentTime + dt
	
	-- pulses the mood color
	local baseColor = self.mood:getColorVec4()
	local shift = math.sin(self.currentTime) * self.colorPulseMaxShift
	baseColor = (baseColor + vec4(shift, shift, shift, shift)):clamp(0, 255)
	self.color = baseColor:asTable()
end

function Background:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, Config.virtualScreenHeight * self.screenRatio, Config.virtualScreenHeight)
end