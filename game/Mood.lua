--[[ 

]]

require("math.vec4")
require("math.num")

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
	
    return self
end

-- Influences the mood by a quantity.
-- Negative quantities influence the mood towards boredom, and positive quantities
-- towards excitement.
function Mood:influence(quantity)
	self.excitement = math.clamp(self.excitement + quantity * self.blockInflunceOnExcitement, 0, 1)
end

-- Returns the color which fits the best the current mood.
function Mood:getColorVec4()
	return self.boredColor:linearInterpolate(self.excitedColor, self.excitement)
end

function Mood:update(dt)
	
end

