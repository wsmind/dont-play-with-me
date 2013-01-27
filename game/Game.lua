--[[
]]

require("math.vec2")
require("math.num")
require("game.Block")
require("game.Config")
require("game.Hero")
require("game.Heart")
require("game.Mood")
require("game.Background")
require("game.Soundtrack")
require("game.TextBlock")

Game = {}
Game.__index = Game

function Game.new(options)
    local self = {}
    setmetatable(self, Game)
	
    -- the game has a virtual height
	self.virtualScreenHeight = Config.virtualScreenHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	self.virtualScreenWidth = self.screenRatio * self.virtualScreenHeight
    
	love.graphics.setFont(love.graphics.newFont(40))
	
	-- camera
    self.camera = vec2(0, 0)
	self.zoom = 1.0
	
	-- mood
	self.mood = Mood.new{
		
	}
	
	-- hero stuff
	self.hero = Hero.new{}
	self.heroMovesLeft = false
	self.heroMovesRight = false
	
	-- blocks
	self.blocks = {}
	local currentX = 0
	for i = 0, 500 do
		local options = {
			x = currentX,
			width = Config.blockWidth + Config.blockWidthVariation * (math.random() - 0.5),
			height = Config.blockHeight + Config.blockHeightVariation * (math.random() - 0.5),
			excitement = math.floor(math.random() * 2) * 2 - 1
		}
		local block = Block.new(options)
		currentX = currentX + options.width + 10
		table.insert(self.blocks, block)
	end
	
	-- text blocks
	self.textBlocks = {}
	
	-- background
	self.background = Background.new{
		mood = self.mood
	}
	
	-- music
	self.soundtrack = Soundtrack.new{}
	--self.soundtrack:prepareCrossfade("piano", "strings")
	
	-- hearts
	self.hearts = {}
	--[[for i = 0, 500 do
		local heart = Heart.new{
			pos = vec2(math.random() * 2000, math.random() * 1000 - 500)
		}
		table.insert(self.hearts, heart)
	end]]--
	
	-- text assets
	self.feedbackTexts = {
		{
			slopeMin = 0,
			slopeMax = 2,
			texts = {
				"Oh yes, that's it!",
				"Apart from being pretty good in here, what do you do?",
				"Wanna go watch a movie later?",
				"Exactly like this!",
				"Yep, you're doing pretty well.",
				"That's quite fun!",
				"Amusing.",
				"I do like it.",
				"I actually enjoy this.",
				"Is it hot in here or is it just you?"
			}
		},
		{
			slopeMin = -2,
			slopeMax = 0,
			texts = {
				"Um... okay... I'm not quite sure about that...",
				"Could you just... stop acting like that?!",
				"Woah, don't behave like an idiot.",
				"Come on, really?",
				"You're kidding me, aren't you?",
				"Haha, funny. Now do it right.",
				"Wait... seriously...?",
				"Ok, um, yeah... well...No... no, i don't like it.",
				"I do not like it. I do not like it at all.",
				"No, really, I'm having more fun with myself.",
				"Wake me up when something exciting happens."
			}
		}
	}
	
	self.score = 0
	
    return self
end

function Game:start()
	self.soundtrack:startAllMute()
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
	end
	
	-- audio choice
	--[[if key == "1" then
		self.soundtrack:playOnly("alpha")
	elseif key == "2" then
		self.soundtrack:playOnly("tonight")
	end]]--
end

function Game:keyReleased(key, unicode)
	-- hero movement
	if key == "left" then
		self.heroMovesLeft = false
	elseif key == "right" then
		self.heroMovesRight = false
	end
end

function Game:update(dt)

	-- mood
	self.mood:update(dt)
	
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
				if excitement then
					local slope = self.mood:influence(excitement)
					if slope then
						if slope > 0 or slope < 0 then
							self:spawnTextBlock(slope, block)
						end
					end
					
					-- spawn heart if it is worth it
					local worth = self.mood:getHeartWorth() - 2
					if math.random() < worth then
						local heart = Heart.new{
							pos = vec2(self.camera.x + 600, math.random() * 200 - 100)
						}
						table.insert(self.hearts, heart)
					end
				end
			end
		end
	end
	
	-- text blocks
	for key, tblock in ipairs(self.textBlocks) do
		tblock:update(dt)
		if tblock:getNeedsDispose() then
			table.remove(self.textBlocks, key)
		end
	end
	
	-- jumping
	if love.keyboard.isDown("up") then
		self.hero:jump()
	end
	
	-- hearts
	for i, heart in ipairs(self.hearts) do
		heart:update(dt)
		
		-- check if the hero can pick this heart
		if heart:tryToTake(self.hero:getBounds()) then
			self.score = self.score + 1
		end
		
		-- check if the heart object can be removed from the update list
		if heart:canBeDestroyed() then
			table.remove(self.hearts, i)
		end
	end
	
	-- scroll screen, function of the mood
	--self.camera.x = self.camera.x + Config.cameraScrollSpeed  * dt
	self.camera.x = self.camera.x + math.linearInterpolate(Config.cameraScrollSpeedMin, Config.cameraScrollSpeedMax, self.mood.excitement) * dt
	
	-- shake camera
	self.camera.y = math.sin(love.timer.getTime() * Config.cameraShakeSpeed) * Config.cameraShakeAmplitude
	
	-- update sound crossfade
	--self.soundtrack:updateCrossfade(self.mood.excitement)
	self.soundtrack:update(dt, self.mood.excitement)
end

function Game:draw()

    -- draw background
	self.background:draw()
	
	love.graphics.push()
	
    -- apply virtual resolution before rendering anything
    love.graphics.scale(self.virtualScaleFactor, self.virtualScaleFactor)
	
	-- apply camera zoom
	love.graphics.scale(self.zoom, self.zoom)
	
    -- move to camera position
    love.graphics.translate((self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x, (self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y)
	
	-- hearts
	for _, heart in ipairs(self.hearts) do
		heart:draw()
	end
	
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
	
	-- draw text blocks
	for _, tblock in ipairs(self.textBlocks) do
		tblock:draw()
	end
	
	-- reset camera transform before hud drawing
	love.graphics.pop()
	
	-- HUD
	if self.hero.grounded then
		love.graphics.setColor(0, 0, 255, 255)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
	
	-- Debug
	love.graphics.print("YOU LOST", 50, 50)
	love.graphics.print(self.mood.hSampleAverage, 100, 100)
	love.graphics.print(self.mood.hSampleSD, 100, 150)
	love.graphics.print(self.mood:getLastPatternSlope(), 100, 200)
	love.graphics.print(self.mood.iExcitementInfluenceRatio, 100, 250)
	love.graphics.print(self.mood:getHeartWorth(), 100, 300)
	love.graphics.print("Score: " .. self.score, 800, 100)
end

function Game:spawnTextBlock(slope, targetBlock)
	-- computes the text color
	local ccolor = nil
	if slope > 0 then
		ccolor = Config.excitedColor
	else
		ccolor = Config.boredColor
	end
	
	-- gets the text value depending on the slope
	local textv = ""
	for k,v in pairs(self.feedbackTexts) do
		if slope > v.slopeMin and slope < v.slopeMax then
			textv = v.texts[math.random(1, #v.texts)]
			print(textv)
		end
	end
	
	-- other pos parameters
	local blockTopHeight = targetBlock:getTopHeight() - 50
	
	-- adds the text on-screen
	table.insert(self.textBlocks, TextBlock.new{
				spawnPos = vec2(targetBlock.x, blockTopHeight),
				anchorPos = self:_screenToWorld(vec2(3 * self.virtualScreenWidth / 4, self.virtualScreenHeight / 3)),
				text = textv,
				color = ccolor
		}
	)
end

function Game:_screenToWorld(vector)
    local screenSpaceCamera = vec2(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    local relativePosition = (vector - screenSpaceCamera) / vec2(self.virtualScaleFactor * self.zoom, self.virtualScaleFactor * self.zoom)
    return relativePosition + self.camera
end
