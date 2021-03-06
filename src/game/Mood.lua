--[[ 

]]

require("math.vec4")
require("math.num")
require("lib.simplestat")
require("game.Config")

Mood = {}
Mood.__index = Mood

function Mood.new(options)
    local self = {}
    setmetatable(self, Mood)
	
	-- excitement and influences
	self.excitement = 0
	self.blockInflunceOnExcitement = 0.1
	self.excitementAverage = 0
	self.excitementAverageSampleCount = 0
	
	-- mood colors
	self.boredColor = Config.boredColor
	self.excitedColor = Config.excitedColor
	
	-- sample collection for the hearts (excitement)
	self.hSampleCount = 16
	self.hSamples = {}
	self.hSampleAverage = 0
	self.hSampleSD = 0
	
	-- sample collection for the hearts (influences)
	self.iSampleCount = 8
	self.iSamples = {}
	self.iExcitementInfluenceRatio = 0 -- proportion of excitement
	self.iCurrentBoredomCount = 0
	self.iCurrentExcitementCount = 0
	
	-- sample collection for the pattern
	self.pSampleCount = 8
	self.pSamples = {}
	self.pSampleAnalysisHistory = {}
	self.pLastSampleAnalysis = 0
	
    return self
end

-- Influences the mood by a quantity.
-- Negative quantities influence the mood towards boredom, and positive quantities
-- towards excitement.
-- Returns a recognized pattern, or nil if none is recognized so far
function Mood:influence(quantity)
	-- update excitement
	self.excitement = math.clamp(self.excitement + quantity * self.blockInflunceOnExcitement, 0, 1)
	
	-- update excitement average
	local ean = self.excitementAverageSampleCount
	self.excitementAverage = ((self.excitementAverage * ean) + self.excitement) / (ean + 1)
	self.excitementAverageSampleCount = self.excitementAverageSampleCount + 1
	
	-- collects the samples
	--self:collectHeartExcitementSamples()
	self:collectHeartInfluenceSamples(quantity)
	local slope = self:collectPatternSamples()
	if not (slope == nil) then
		self.pLastSampleAnalysis = slope
	end
	-- returns an event?
	return slope
end

-- Returns the color which fits the best the current mood.
function Mood:getColorVec4()
	return self.boredColor:linearInterpolate(self.excitedColor, self.excitement)
end

-- Returns how many hearts the player deserves now
function Mood:getHeartWorth()
	local worth = 0
	local r = self.iExcitementInfluenceRatio
	local dr = math.min(math.abs(r - 1/3), math.abs(r - 2/3))
	
	return Config.maxHeartWorth * (1 - 3 * dr)
end

function Mood:update(dt)
	
end

--[[function Mood:collectHeartExcitementSamples()
	-- pops the first value of the table if the sample count has been reached
	if #self.hSamples == self.hSampleCount then
		table.remove(self.hSamples, 0)
	end
	
	-- queues the current value
	table.insert(self.hSamples, self.excitement)
	
	-- updates the statistical values
	self.hSampleAverage = stats.mean(self.hSamples)
	self.hSampleSD = stats.standardDeviation(self.hSamples)
end]]--

function Mood:collectHeartInfluenceSamples(lastInfluence)
	local boredomCount = self.iCurrentBoredomCount
	local excitementCount = self.iCurrentExcitementCount
	
	-- pops the first value of the table if the sample count has been reached
	if #self.iSamples == self.iSampleCount then
		-- gets the value to pop.
		local popedV = self.iSamples[1]
		
		-- removes the value
		table.remove(self.iSamples, 1)
		
		-- updates the count
		if popedV < 0 then
			boredomCount = boredomCount - 1
		else
			excitementCount = excitementCount - 1
		end
	end
	
	-- queues the current value
	table.insert(self.iSamples, lastInfluence)
	
	-- updates the counts
	if lastInfluence < 0 then
		boredomCount = boredomCount + 1
	else
		excitementCount = excitementCount + 1
	end
	self.iCurrentBoredomCount = boredomCount
	self.iCurrentExcitementCount = excitementCount
	
	-- updates the ratio
	if boredomCount == 0 and excitementCount == 0 then
		self.iExcitementInfluenceRatio = 0
	else
		self.iExcitementInfluenceRatio = excitementCount / (boredomCount + excitementCount)
	end
end

function Mood:collectPatternSamples()	
	-- collects the data
	table.insert(self.pSamples, self.excitement)
	
	-- analyses the current window if its maximum has been reached
	if #self.pSamples >= self.pSampleCount then
		-- gets the slope of the sample collection
		local slope = self:getPatternSamplesSlope(self.pSamples)
		
		-- adds it to the history
		table.insert(self.pSampleAnalysisHistory, slope)
		
		-- clears the table
		self.pSamples = {}
		
		return slope
	else
		return nil
	end
end

function Mood:getLastPatternSlope()
	return self.pLastSampleAnalysis
end

function Mood:getPatternSamplesSlope(samples)
	--
	-- performs linear regression on the samples and gets the slope
	--
	
	-- gets the parameters
	local sx = 0
	local sy = 0
	local sxx = 0
	local sxy = 0
	local syy = 0
	local n = #samples
	for k,v in ipairs(samples) do
        sx = sx + k
		sy = sy + v
		sxy = sxy + (k * v)
		sxx = sxx + (k * k)
		syy = syy + (v * v)
    end	
	
	-- computes the slope
	local b = (n * sxy - sx * sy) / (n * sxx - sx * sx)
	
	return b
	
end
