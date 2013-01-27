
require("game.Config")
require("math.table")
require("lib.simplestat")

GameOverScene = {}
GameOverScene.__index = GameOverScene

function GameOverScene.new(options)
    local self = {}
    setmetatable(self, GameOverScene)
	
	self.currentPageSource = nil
	self.currentPageWidth = 0
	self.currentPageHeight = 0
	self.currentPageScaleX = 1
	self.currentPageScaleY = 1
	
	self.font = love.graphics.newFont("assets/fonts/Dimbo Regular.ttf", 30)
	
	self.outcomeTexts = {
		{
			text = ""
		}
			
	}
	
	self.score = 0
	
	-- analyses the game outcome and displays stuff
	self:initFromGameOutcome(options)
		
    return self
end

function GameOverScene:initFromGameOutcome(options)
	-- find out how well the player has matched the seduction pattern
	local patternScore = self:getPatternFit(options.mood.pSampleAnalysisHistory)
	
	-- image
	self.currentPageSource = love.graphics.newImage("assets/outro/Ending01-Best.png")
	self.currentPageSource:setFilter("nearest","nearest")
	self.currentPageWidth = self.currentPageSource:getWidth()
	self.currentPageHeight = self.currentPageSource:getHeight()
	
	-- score
	self.score = options.score
end

function GameOverScene:getPatternFit(analysisHistory)
	local n = #analysisHistory
	if n == 0 then
		return 0
	end
	
	local step = math.floor(n / 3)
	
	-- defines the different parts of the analysis
	local aHook = table.slice(analysisHistory, 0, step)
	local aCalm = table.slice(analysisHistory, step + 1, 2 * step)
	local aClimax = table.slice(analysisHistory, 2 * step + 1, n)
	
	local slopeAvg = stats.mean(analysisHistory)
	
	local score = 0

	return score
end

function GameOverScene:keyPressed(key, unicode)
	
end

function GameOverScene:keyReleased(key, unicode)
	
end

function GameOverScene:update(dt)
	
end

function GameOverScene:draw()
	
	-- background
	--love.graphics.draw(self.currentPageSource, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, self.currentPageScaleX, self.currentPageScaleY, self.currentPageWidth / 2, self.currentPageHeight / 2)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.currentPageSource, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, self.currentPageScaleX, self.currentPageScaleY, self.currentPageWidth / 2, self.currentPageHeight / 2)
	
	-- text
	love.graphics.setFont(self.font)
	love.graphics.print("Press any key to retry.", love.graphics.getWidth() / 2 - 100, 3 * love.graphics.getHeight() / 4)
	love.graphics.setColor(Config.cBlank:asTable())
	love.graphics.print("Game Over!", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2)
	love.graphics.print(self.score, love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 80)
	
	--love.graphics.setColor(Config.cLight:asTable())
	--love.graphics.print("Press any key.", self.virtualScreenWidth / 2 - 100, self.virtualScreenHeight / 3)
end