--[[ 
The NoName Fiber Game
Copyright (c) 2012 Aurélien Defossez, Jean-Marie Comets, Anis Benyoub, Rémi Papillié
]]

require("math.vec2")
require("game.Block")

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
	
    --music = love.audio.newSource(gameConfig.sound.generaltheme)
    --love.audio.play(music)
	
	self.blocks = {}
	for i = 20, 200 do
		local block = Block.new{
			x = i * 25,
			width = 25,
			height = math.random(500)
		}
		table.insert(self.blocks, block)
	end
	
    return self
end

function Game:mousePressed(x, y, button)
end

function Game:mouseReleased(x, y, button)
end

function Game:keyPressed(key, unicode)
	self.pressed = true
end

function Game:keyReleased(key, unicode)
	self.pressed = false
end

function Game:update(dt)
	for _, block in ipairs(self.blocks) do
		block:update(dt)
	end
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
	
	-- draw blocks
	for _, block in ipairs(self.blocks) do
		block:draw()
	end
	
	-- draw cool pressed stuff
	if self.pressed then
		love.graphics.rectangle("fill", -200, 0, 100, 1080 / 2)
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
