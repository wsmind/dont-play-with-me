--[[
]]

require("math.vec2")
require("game.Block")
require("game.Config")
require("game.Hero")
require("game.Mood")
require("game.Background")

Game = {}
Game.__index = Game

function Game.new(options)
    local self = {}
    setmetatable(self, Game)
	
    -- the game has a virtual height
	self.virtualScreenHeight = Config.virtualScreenHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
    
	love.graphics.setFont(love.graphics.newFont(40))
	
	-- camera
    self.camera = vec2(0, 0)
	self.zoom = 1.0
	
	-- mood
	self.mood = Mood.new{}
	
	-- hero stuff
	self.hero = Hero.new{}
	self.heroMovesLeft = false
	self.heroMovesRight = false
	self.heroInPostJumping = false
	
    --music = love.audio.newSource(gameConfig.sound.generaltheme)
    --love.audio.play(music)
	
	-- blocks
	self.blocks = {}
	local currentX = 0
	for i = 0, 500 do
		local options = {
			x = currentX,
			width = Config.blockWidth + Config.blockWidthVariation * (math.random() - 0.5),
			height = Config.blockHeight + Config.blockHeightVariation * (math.random() - 0.5),
			excitement = math.random(2) * 2 - 2
		}
		local block = Block.new(options)
		currentX = currentX + options.width
		table.insert(self.blocks, block)
	end
	
	-- background
	self.background = Background.new{
		mood = self.mood
	}
	
    return self
end

function Game:mousePressed(x, y, button)
end

function Game:mouseReleased(x, y, button)
end

function Game:keyPressed(key, unicode)
	-- hero movement
	if key == "left" then
		self.heroMovesLeft = true
	elseif key == "right" then
		self.heroMovesRight = true
	elseif key == "up" and not self.heroInPostJumping then
		self.heroInPostJumping = true
		self.hero:jump()
	end
end

function Game:keyReleased(key, unicode)
	-- hero movement
	if key == "left" then
		self.heroMovesLeft = false
	elseif key == "right" then
		self.heroMovesRight = false
	elseif key == "up" then
		self.heroInPostJumping = false
	end
end

function Game:update(dt)
	-- background
	self.background:update(dt)
	
	-- updates hero
	local heroTotalMove = vec2(0,0)
	if self.heroMovesLeft then
		heroTotalMove = heroTotalMove - Config.heroHorizontalSpeed
	end	
	if self.heroMovesRight then
		heroTotalMove = heroTotalMove + Config.heroHorizontalSpeed
	end
	
	-- performs move
	self.hero:move(heroTotalMove)
	self.hero:update(dt)
	
	self.collision = false
	
	-- blocks
	for _, block in ipairs(self.blocks) do
		block:update(dt)
		
		local collisionInfo = block:collide(self.hero:getBounds())
		if collisionInfo then
			self.collision = true
			if self.hero:handleCollision(collisionInfo) then
				local excitement = block:activate()
				-- Mood.influence(excitement)
			end
		end
	end
end

function Game:draw()
    -- draw background
	--local screenExtent = vec2(self.virtualScreenHeight * self.screenRatio, self.virtualScreenHeight)
	--local cameraBounds = aabb(self.camera - screenExtent, self.camera + screenExtent)
    --self.map:draw(cameraBounds)
	self.background:draw()
	
	
	love.graphics.push()
	
    -- apply virtual resolution before rendering anything
    love.graphics.scale(self.virtualScaleFactor, self.virtualScaleFactor)
	
	-- apply camera zoom
	love.graphics.scale(self.zoom, self.zoom)
	
    -- move to camera position
    love.graphics.translate((self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x, (self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y)

	-- draw hero
	if self.collision then
		love.graphics.setColor(255, 0, 0, 255)
	else
		love.graphics.setColor(255, 0, 255, 255)
	end
	self.hero:draw()
	
	-- draw blocks
	for _, block in ipairs(self.blocks) do
		block:draw()
	end
	
	-- reset camera transform before hud drawing
	love.graphics.pop()
	
	-- HUD
	if self.hero.grounded then
		love.graphics.setColor(0, 0, 255, 255)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
	love.graphics.print("YOU LOST", 50, 50)
end

function Game:_screenToWorld(vector)
    local screenSpaceCamera = vec2(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    local relativePosition = (vector - screenSpaceCamera) / vec2(self.virtualScaleFactor * self.zoom, self.virtualScaleFactor * self.zoom)
    return relativePosition + self.camera
end
