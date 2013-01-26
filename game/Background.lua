--[[ 

]]

Background = {}
Background.__index = Background

function Background.new(options)
    local self = {}
    setmetatable(self, Background)
	
	self.mood = options.mood
	
	self.color = self.mood:getColor()
	
	self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	
    return self
end

function Background:update(dt)
	self.color = self.mood:getColor()
end

function Background:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, Config.virtualScreenHeight * self.screenRatio, Config.virtualScreenHeight)
end