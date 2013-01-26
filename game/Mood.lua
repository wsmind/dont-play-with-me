--[[ 

]]

Mood = {}
Mood.__index = Mood

function Mood.new(options)
    local self = {}
    setmetatable(self, Mood)
	
	self.excitement = 0
	self.blockInflunceOnExcitement = 0.1
	
    return self
end

-- Influences the mood by a quantity.
-- Negative quantities influence the mood towards boredom, and positive quantities
-- towards excitement.
function Mood:influence(quantity)
	self.excitement = math.min(1, math.max(0, self.excitement + quantity * self.blockInflunceOnExcitement))
end

-- Returns the color which fits the best the current mood.
function Mood:getColor()
	return {255 * self.excitement, 0, 255 * (1 - self.excitement), 255}
end

function Mood:update(dt)
	
end