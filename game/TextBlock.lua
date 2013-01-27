
require("math.vec2")
require("game.Config")

TextBlock = {}
TextBlock.__index = TextBlock

function TextBlock.new(options)
    local self = {}
    setmetatable(self, TextBlock)
	
	self.text = options.text
	self.spawnPos = options.spawnPos
	self.anchorPos = options.anchorPos
	self.color = options.color:asTable()
	
	self.pos = vec2(self.anchorPos.x, self.anchorPos.y)
	
	self.currentTime = 0
	self.needsDispose = false
	
    return self
end

function TextBlock:update(dt)
	self.currentTime = self.currentTime + dt
	
	-- interpolation from spawnPos to anchorPos
	local spawnTime = Config.textBlockSpawnDuration - self.currentTime
	print(spawnTime)
	if spawnTime >= 0 and spawnTime <= 1 then
		self.pos = self.spawnPos:linearInterpolate(self.anchorPos, spawnTime)
	end
	
	-- does the block need to say good bye?
	if self.currentTime > Config.textBlockDurationOnScreen then
		self.needsDispose = true
	end
end

function TextBlock:draw()
	love.graphics.setColor(self.color)
	love.graphics.print(self.text, self.pos.x, self.pos.y)
end

function TextBlock:getNeedsDispose()
	return self.needsDispose
end