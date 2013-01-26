--[[ 
]]

require("math.aabb")
require("math.vec2")

Block = {}
Block.__index = Block

function Block.new(options)
    local self = {}
    setmetatable(self, Block)
	
	self.x = options.x
	self.width = options.width
	self.height = options.height
	
    return self
end

function Block:update(dt)
	self.x = self.x - dt * 40
	self.height = self.height + math.sin(self.x * 0.1) * 5
	
	self.aabb = aabb(vec2(self.x - self.width * 0.5, 540 - self.height), vec2(self.x + self.width * 0.5, 540))
end

function Block:collide(aabb)
	return self.aabb:collide(aabb)
end

function Block:draw()
	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.rectangle("fill", self.x - self.width * 0.5, 540 - self.height, self.width, self.height)
	
	self.aabb:draw(255, 255, 255, 255)
end