--[[ 
The NoName Fiber Game
Copyright (c) 2012 Aurélien Defossez, Jean-Marie Comets, Anis Benyoub, Rémi Papillié
]]

require("math.vec2")
require("game.Config")
require("game.Hero")

Game = {}
Game.__index = Game

function Game.new(options)
    local self = {}
    setmetatable(self, Game)
	
    -- the game has a virtual height
	self.virtualScreenHeight = 1080
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
    
	love.graphics.setFont(love.graphics.newFont(40))
	
    self.camera = vec2(0, 0)
	self.zoom = 1.0
	
	-- hero stuff
	self.hero = Hero:new{}
	self.heroMovesLeft = false
	self.heroMovesRight = false
	
    --music = love.audio.newSource(gameConfig.sound.generaltheme)
    --love.audio.play(music)
	
    return self
end

function Game:mousePressed(x, y, button)
end

function Game:mouseReleased(x, y, button)
end

function Game:keyPressed(key, unicode)
	self.pressed = true
	
	-- hero movement
	if key == "left" then
		self.heroMovesLeft = true
	elseif key == "right" then
		self.heroMovesRight = true
	end
end

function Game:keyReleased(key, unicode)
	self.pressed = false
	
	-- hero movement
	if key == "left" then
		self.heroMovesLeft = false
	elseif key == "right" then
		self.heroMovesRight = false
	end
end

function Game:update(dt)
	
	-- updates hero
	local heroTotalMove = vec2(0,0)
	if self.heroMovesLeft then
		heroTotalMove = heroTotalMove - Config.heroHorizontalSpeed
	end	
	if self.heroMovesRight then
		heroTotalMove = heroTotalMove + Config.heroHorizontalSpeed
	end
	self.hero:move(heroTotalMove)
	self.hero:update(dt)
	
end

function Game:draw()
	love.graphics.push()
	
    -- apply virtual resolution before rendering anything
    love.graphics.scale(self.virtualScaleFactor, self.virtualScaleFactor)
	
	-- apply camera zoom
	love.graphics.scale(self.zoom, self.zoom)
	
    -- move to camera position
    love.graphics.translate((self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x, (self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y)
	
    -- draw background
	--local screenExtent = vec2(self.virtualScreenHeight * self.screenRatio, self.virtualScreenHeight)
	--local cameraBounds = aabb(self.camera - screenExtent, self.camera + screenExtent)
    --self.map:draw(cameraBounds)
	
	-- draw hero
	self.hero:draw()
	
	-- draw blocks
	love.graphics.rectangle("fill", 0, 0, 100, 50)
	
	-- draw cool pressed stuff
	if self.pressed then
		love.graphics.rectangle("fill", -200, 0, 100, 50)
	end
	
	-- reset camera transform before hud drawing
	love.graphics.pop()
	
	-- HUD
	love.graphics.print("YOU LOST", 50, 50)
end

function Game:_screenToWorld(vector)
    local screenSpaceCamera = vec2(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    local relativePosition = (vector - screenSpaceCamera) / vec2(self.virtualScaleFactor * self.zoom, self.virtualScaleFactor * self.zoom)
    return relativePosition + self.camera
end
