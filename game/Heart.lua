--[[ 

]]

require("math.aabb")
require("math.vec2")

local anim8 = require("lib.anim8")

Heart = {}
Heart.__index = Heart

function Heart.new(options)
    local self = {}
    setmetatable(self, Heart)
	
	self.pos = options.pos
	
	local extent = vec2(8, 8)
	self.aabb = aabb(self.pos - extent * Config.heartScale, self.pos + extent * Config.heartScale)
	
	self.image = love.graphics.newImage("assets/heart/Heart.png")
	self.image:setFilter("nearest", "nearest")
	
	local grid = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
	self.animations = {
		idle = anim8.newAnimation("loop", grid(1, 2, 2, 2), 1, {0.6, 0.2}),
		appear = anim8.newAnimation("once", grid(4, 3, 3, 3, 2, 3, 1, 3), 0.2),
		disappear = anim8.newAnimation("once", grid(1, 1, 2, 1, 3, 1, 4, 1), 0.1)
	}
	self:playAnimation("appear")
	
	self.taken = false
	
    return self
end

function Heart:playAnimation(name)
	local anim = self.animations[name]
	if not (self.currentAnimation == anim) then
		self.currentAnimation = self.animations[name]
		self.currentAnimation:gotoFrame(1)
		self.currentAnimation:resume()
	end
end

function Heart:tryToTake(heroBounds)
	if self.taken then
		return false
	end
	
	if self.aabb:collide(heroBounds) then
		self.taken = true
		return true
	end
	
	return false
end

function Heart:canBeDestroyed()
	-- we can be destroyed after the disappearing animation has finished
	return self.taken and (self.currentAnimation.status ~= "playing")
end

function Heart:update(dt)
	-- animation state
	if self.taken == false then
		if self.currentAnimation.status ~= "playing" then
			-- spawn finished
			self:playAnimation("idle")
		end
	else
		self:playAnimation("disappear")
	end
	
	self.currentAnimation:update(dt)
end

function Heart:draw()
	love.graphics.setColor(255, 255, 255, 255)
	self.currentAnimation:draw(self.image, self.pos.x, self.pos.y, 0, Config.heartScale, Config.heartScale, 16, 16)
	
	--self.aabb:drawDebug(255, 0, 0, 255)
end
