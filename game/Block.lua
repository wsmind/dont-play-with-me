--[[ 
]]

require("math.aabb")
require("math.vec2")
require("game.Config")

Block = {}
Block.__index = Block

function Block.loadResources()
	Block.grassLeft = love.graphics.newImage("assets/grass/Gras-left01.png")
	Block.grassLeft:setFilter("nearest", "nearest")
	
	Block.grassRight = love.graphics.newImage("assets/grass/Gras-right01.png")
	Block.grassRight:setFilter("nearest", "nearest")
	
	Block.grassMiddle = {
		love.graphics.newImage("assets/grass/Gras-middle01.png"),
		love.graphics.newImage("assets/grass/Gras-middle02.png")
	}
	Block.grassMiddle[1]:setFilter("nearest", "nearest")
	Block.grassMiddle[2]:setFilter("nearest", "nearest")
end

function Block.new(options)
    local self = {}
    setmetatable(self, Block)
	
	self.x = options.x
	self.width = options.width
	self.height = options.height
	self.excitement = options.excitement
	self.activated = false
	self.activationTime = 0
	self.animPhase = math.random() * 2 * math.pi
	
	-- get the color from the excitement
	if self.excitement > 0 then
		self.color = Config.excitedColor
	else
		self.color = Config.boredColor
	end
	
	-- then randomize it a bit
	local colorVariation = vec4(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, 0) * Config.blockColorVariation
	self.color = self.color + colorVariation
	self.color = self.color:clamp(0, 255)
	
    return self
end

function Block:update(dt)
	--self.x = self.x - dt * Config.scrollSpeed
	--self.height = self.height + math.sin(self.x * 0.02) * 5
	
	if self.activated then
		self.activationTime = self.activationTime + dt
		self.color = vec4(20, 20, 20, 255) + vec4(235, 235, 235, 0) * math.exp(-self.activationTime * 2)
	end
	
	self.animHeight = self.height + math.sin(love.timer.getTime() * Config.blockAnimSpeed + self.animPhase) * Config.blockAnimSize
	
	self.aabb = aabb(vec2(self.x, Config.blockBase - self.animHeight), vec2(self.x + self.width, Config.blockBase))
end

function Block:collide(aabb)
	return self.aabb:collide(aabb)
end

function Block:activate()
	if self.activated then
		return nil
	end
	
	-- deactivate the block
	self.activated = true
	self.color = vec4(20, 20, 20, 255)
	
	return self.excitement
end

function Block:getTopHeight()
	return Config.blockBase - self.animHeight
end

function Block:draw()
	love.graphics.setColor(self.color.x, self.color.y, self.color.z, self.color.w)
	
	love.graphics.rectangle("fill", self.x, Config.blockBase - self.animHeight, self.width, self.animHeight)
	
	-- grass
	local grassColor = vec4(255, 255, 255, 255) * 0.7 + self.color * 0.3
	local leftStart = self.x - Config.blockSpacing * 0.5
	local leftEnd = leftStart + 32 * Config.spriteScale
	local rightEnd = self.x + self.width + Config.blockSpacing * 0.5
	local rightStart = rightEnd - 32 * Config.spriteScale
	local grassHeight = Config.blockBase - self.animHeight - 16
	love.graphics.setColor(grassColor:asTable())
	love.graphics.draw(Block.grassLeft, leftStart, grassHeight, 0, Config.spriteScale, Config.spriteScale)
	love.graphics.draw(Block.grassRight, rightStart, grassHeight, 0, Config.spriteScale, Config.spriteScale)
	
	local middleCount = math.floor((rightStart - leftEnd) / (32 * Config.spriteScale) + 1)
	for i = 1, middleCount do
		love.graphics.draw(Block.grassMiddle[1], leftStart + i * 32 * Config.spriteScale, grassHeight, 0, Config.spriteScale, Config.spriteScale)
	end
	
	--self.aabb:drawDebug(255, 255, 255, 255)
end
