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
	
	-- get the color from the excitement
	if self.excitement > 0 then
		self.color = Config.excitedColor
	else
		self.color = Config.boredColor
	end
	
	-- then randomize it a bit
	local colorVariation = vec4(255, 255, 255, 0) * (math.random() * 2 - 1) * Config.blockColorVariation
	self.color = self.color + colorVariation
	self.color = self.color:clamp(0, 255)
	
    return self
end

function Block:update(dt)
	--self.x = self.x - dt * Config.scrollSpeed
	--self.height = self.height + math.sin(self.x * 0.02) * 5
	
	self.aabb = aabb(vec2(self.x, Config.blockBase - self.height), vec2(self.x + self.width, Config.blockBase))
end

function Block:collide(aabb)
	return self.aabb:collide(aabb)
end

function Block:activate()
	if self.activated then
		return 0
	end
	
	-- deactivate the block
	self.activated = true
	self.color = vec4(20, 20, 20, 255)
	
	return self.excitement
end

function Block:draw()
	love.graphics.setColor(self.color.x, self.color.y, self.color.z, self.color.w)
	
	love.graphics.rectangle("fill", self.x, Config.blockBase - self.height, self.width, self.height)
	
	--self.aabb:drawDebug(255, 255, 255, 255)
end
