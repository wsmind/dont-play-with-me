
require("game.Config")
require("math.table")
require("math.num")
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
	
	self.fontBig = love.graphics.newFont("assets/fonts/Dimbo Regular.ttf", 30)
	self.fontSmall = love.graphics.newFont("assets/fonts/Dimbo Regular.ttf", 20)
	
	self.outcomeText = ""
	self.hintText = ""
	
	self.patternUnlocked = false
	self.patternScore = 0
	
	self.hintTexts = {
		
	}
	
	self.score = 0
	
	-- analyses the game outcome and displays stuff
	self:initFromGameOutcome(options)
		
    return self
end

function GameOverScene:initFromGameOutcome(options)
	-- find out how well the player has matched the seduction pattern
	local patternScore = self:getPatternFit(options.mood.pSampleAnalysisHistory)
	
	-- game outcome and image selection
	local isBest = false
	local isExcited = false
	local isPositive = false
	
	self.patternScore = math.round(patternScore * 100, 1)
	if patternScore >= 1 and not options.isPlayerFault then
		self.patternUnlocked = true
	end
	
	if self.patternUnlocked or options.score >= 25 then
		isBest = true
	else
		if options.mood.excitementAverage >= 0.5 then
			isExcited = true
		end
		
		if patternScore >= 0.6 or options.score >= 10 then
			isPositive = true
		end
	end
	
	print("final excitement avg: "..options.mood.excitementAverage)
	
	-- image selection
	if isBest then
	
		-- best
		self.currentPageSource = love.graphics.newImage("assets/outro/Ending01-Best.png")
		self.outcomeText = "I'm the luckiest\ngame in the world!"
		
	elseif not isExcited and not isPositive then
	
		-- bored negative
		self.currentPageSource = love.graphics.newImage("assets/outro/Ending02-Bored-negative.png")
		self.outcomeText = "I'm not that kind\nof game. :("
		
	elseif isPositive and not isExcited then
	
		-- bored positive
		self.currentPageSource = love.graphics.newImage("assets/outro/Ending02-Bored-positive.png")
		self.outcomeText = "Well, we can still\nbe friends. :)"
		
	elseif isExcited and not isPositive then
	
		-- excited negative
		self.currentPageSource = love.graphics.newImage("assets/outro/Ending02-Excited-negative.png")
		self.outcomeText = "You're too much to\ndeal with. :("
		
	elseif isExcited and isPositive then
	
		-- excited positive
		self.currentPageSource = love.graphics.newImage("assets/outro/Ending02-Excited-positive.png")
		self.outcomeText = "You're a\nrollercoaster! :)"
		
	else
		print("unknown game outcome!")
		self.currentPageSource = love.graphics.newImage("assets/outro/Ending02-Bored-negative.png")
		self.outcomeText = "You're special..."
	end
	
	-- image setup
	self.currentPageSource:setFilter("nearest","nearest")
	self.currentPageWidth = self.currentPageSource:getWidth()
	self.currentPageHeight = self.currentPageSource:getHeight()
	
	-- score
	self.score = options.score
end

-- Gets how much the "seduction pattern" has been fit by the player
function GameOverScene:getPatternFit(analysisHistory)
	local n = #analysisHistory
	if n == 0 then
		return 0
	end
	
	local step = math.floor(n / 3)
	if step < 1 then
		return 0
	end
	
	-- defines the different parts of the analysis
	local aHook = table.slice(analysisHistory, 1, step)
	local aCalm = table.slice(analysisHistory, step + 1, 2 * step)
	local aClimax = table.slice(analysisHistory, 2 * step + 1, n)
	
	local slopeAvg = stats.mean(analysisHistory)
	
	--local aHookMean = stats.mean(aHook)
	local aHookMax = table.max(aHook)[2]
	--local aCalmMean = stats.mean(aCalm)
	local aCalmMin = table.min(aCalm)[2]
	--local aClimaxMean = stats.mean(aClimax)
	local aClimaxMax = table.max(aClimax)[2]
	
	local score = 0
	
	local function allPos(t) return table.every(t, function(a) return a >= 0 end) end
	local function allNeg(t) return table.every(t, function(a) return a <= 0 end) end
	
	print("pattern fit score initial: "..score.." (analysis starts for "..#analysisHistory.." samples, step "..step..")")
	
	-- hook part: the average curve needs to be positive
	if #aHook > 0 then
		print("aHookMax "..aHookMax)
		if aHookMax > 0 then
			score = score + aHookMax / 0.02
		else
			score = score - 2
		end
		print("pattern fit score after hook: "..score.." (over "..#aHook.." samples)")
	end
	
	-- calm part : the average curve needs to be negative
	if #aCalm > 0 then
		print("aCalmMin "..aCalmMin)
		if aCalmMin < 0 then
			score = score + aCalmMin / -0.01
		else
			score = score - 2
		end
		print("pattern fit score after calm: "..score.." (over "..#aCalm.." samples)")
	end
	
	-- climax part : the average curve needs to be positive and big
	if #aClimax > 0 then
		print("aClimaxMax "..aClimaxMax)
		if aClimaxMax > 0 then
			score = score + aClimaxMax / 0.03
		else
			score = score - 2
		end
		print("pattern fit score after climax: "..score.." (over "..#aClimax.." samples)")
	end
	
	-- bonus : calm < hook < climax
	if aCalmMin < aHookMax and aHookMax < aClimaxMax then
		score = score + 1
	else
		--score = score - 3
	end
	print("pattern fit score after bonus pattern: "..score)
	
	-- bonus : all pos, all neg, all pos
	if allPos(aHook) and allNeg(aCalm) and allPos(aClimax) then
		score = score + 2
	else
		--score = score - 3
	end
	print("pattern fit score after bonus consistency: "..score)

	print("final pattern fit score: "..score)
	return score / 10
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
	
	-- big text
	love.graphics.setFont(self.fontBig)
	if self.patternUnlocked then
		love.graphics.print("You have followed the secret seduction pattern! ("..self.patternScore.."%)", love.graphics.getWidth() / 2 - 275, love.graphics.getHeight() / 4 - 100)
	end
	love.graphics.print("Press Enter to retry.", love.graphics.getWidth() / 2 - 100, 3 * love.graphics.getHeight() / 4)
	--love.graphics.print(self.hint, love.graphics.getWidth() / 2 - 100, 3 * love.graphics.getHeight() / 4)
	
	love.graphics.setColor(Config.cBlank:asTable())
	love.graphics.print(self.score, love.graphics.getWidth() / 2 - 55, love.graphics.getHeight() / 2 - 75)
	
	-- small text
	love.graphics.setFont(self.fontSmall)
	love.graphics.print(self.outcomeText, love.graphics.getWidth() / 2 - 60, love.graphics.getHeight() / 2)
	
	--love.graphics.setColor(Config.cLight:asTable())
	--love.graphics.print("Press any key.", self.virtualScreenWidth / 2 - 100, self.virtualScreenHeight / 3)
end