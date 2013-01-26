--[[ 
]]

require("math.aabb")
require("math.vec2")
require("game.Config")

Block = {}
Block.__index = Block

function Block.new(options)
    local self = {}
    setmetatable(self, Block)
	
	self.x = options.x
	self.width = options.width
	self.height = options.height
	self.excitement = options.excitement
	self.activated = false
	
    return self
end

function Block:update(dt)
	self.x = self.x - dt * Config.scrollSpeed
	self.height = self.height + math.sin(self.x * 0.02) * 5
	
	self.aabb = aabb(vec2(self.x, 540 - self.height), vec2(self.x + self.width, 540))
end

function Block:collide(aabb)
	return self.aabb:collide(aabb)
end

function Block:activate()
	if self.activated then
		return 0
	end
	
	self.activated = true
	return self.excitement
end

function Block:draw()
	if not self.activated then
		-- usable block; blue if boring, red if exciting
		if self.excitement > 0 then
			love.graphics.setColor(255, 0, 0, 255)
		else
			love.graphics.setColor(21, 19, 101, 255)
		end
	else
		-- deactivated -> black
		love.graphics.setColor(20, 20, 20, 255)
	end
	
	love.graphics.rectangle("fill", self.x, 540 - self.height, self.width, self.height)
	
	--self.aabb:drawDebug(255, 255, 255, 255)
end
