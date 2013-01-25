--[[ 

]]

require("math.vec2")

Hero = {}
Hero.__index = Hero

function Hero.new(options)
    local self = {}
    setmetatable(self, Hero)
	
	self.pos = vec2(0,0)
	
    return self
end

function Hero:move(movement)
	self.pos = self.pos + movement
end

function Hero:update(dt)

end

function Hero:draw()
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 60, 120)
end