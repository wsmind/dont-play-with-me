--[[ 
]]

require("math.aabb")
require("math.vec2")
require("game.Config")

Block = {}
Block.__index = Block

function Block.loadResources()
	
	Block.grassStyles = {
		-- short
		{
			left = love.graphics.newImage("assets/grass/Gras-left01.png"),
			right = love.graphics.newImage("assets/grass/Gras-right01.png"),
			middle = {
				love.graphics.newImage("assets/grass/Gras-middle01.png"),
				love.graphics.newImage("assets/grass/Gras-middle02.png")
			}
		},
		
		-- long
		{
			left = love.graphics.newImage("assets/grass/Gras-left01_long.png"),
			right = love.graphics.newImage("assets/grass/Gras-right01_long.png"),
			middle = {
				love.graphics.newImage("assets/grass/Gras-middle01_long.png"),
				love.graphics.newImage("assets/grass/Gras-middle02_long.png")
			}
		}
	}
	
	for _,v in ipairs(Block.grassStyles) do
		v.left:setFilter("nearest", "nearest")
		v.right:setFilter("nearest", "nearest")
		v.middle[1]:setFilter("nearest", "nearest")
		v.middle[2]:setFilter("nearest", "nearest")
	end

	Block.activationSound = love.audio.newSource("assets/sfx/block-activation.mp3", "static")
	Block.activationSound:setVolume(0.5)
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
	self.animHeight = 0
	
	-- choose grass
	self.grass = Block.grassStyles[math.floor(math.random(1, #Block.grassStyles))]
	
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
		self.color = vec4(10, 10, 10, 255) + vec4(245, 245, 245, 0) * math.exp(-self.activationTime * 2)
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
	
	-- activate the block
	self.activated = true
	self.color = vec4(20, 20, 20, 255)
	Block.activationSound:play()
	
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
	love.graphics.draw(self.grass["left"], leftStart, grassHeight, 0, Config.spriteScale, Config.spriteScale)
	love.graphics.draw(self.grass["right"], rightStart, grassHeight, 0, Config.spriteScale, Config.spriteScale)
	
	local middleCount = math.floor((rightStart - leftEnd) / (32 * Config.spriteScale) + 1)
	for i = 1, middleCount do
		love.graphics.draw(self.grass["middle"][(i % 2) + 1], leftStart + i * 32 * Config.spriteScale, grassHeight, 0, Config.spriteScale, Config.spriteScale)
	end
	
	--self.aabb:drawDebug(255, 255, 255, 255)
end
