--[[ 

]]

require("math.vec4")
require("math.num")
require("lib.simplestat")

Mood = {}
Mood.__index = Mood

function Mood.new(options)
    local self = {}
    setmetatable(self, Mood)
	
	-- excitement and influences
	self.excitement = 0
	self.blockInflunceOnExcitement = 0.1
	
	-- mood colors
	self.boredColor = vec4(21, 19, 101, 255)
	self.excitedColor = vec4(255, 0, 0, 255)
	
	-- sample collection
	self.sampleCount = 16
	self.samples = {}
	self.sampleAverage = 0
	self.sampleSD = 0
	
    return self
end

-- Influences the mood by a quantity.
-- Negative quantities influence the mood towards boredom, and positive quantities
-- towards excitement.
function Mood:influence(quantity)
	-- update excitement
	self.excitement = math.clamp(self.excitement + quantity * self.blockInflunceOnExcitement, 0, 1)
	
	-- collects the samples
	self:collectSample()
end

-- Returns the color which fits the best the current mood.
function Mood:getColorVec4()
	return self.boredColor:linearInterpolate(self.excitedColor, self.excitement)
end

function Mood:collectSample()
	-- pops the first value of the table if the sample count has been reached
	if #self.samples == self.sampleCount then
		table.remove(self.samples, 0)
	end
	
	-- queues the current value
	table.insert(self.samples, self.excitement)
	
	-- updates the statistical values
	self.sampleAverage = stats.mean(self.samples)
	self.sampleSD = stats.standardDeviation(self.samples)
end

function Mood:update(dt)
	
end