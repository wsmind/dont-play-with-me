--[[ 

]]

require("math.aabb")
require("math.vec2")

Hero = {}
Hero.__index = Hero

function Hero.new(options)
    local self = {}
    setmetatable(self, Hero)
	
	self.pos = vec2(0,0)
	self.velocity = vec2(0,0)
	self.groundPlaneY = Config.virtualScreenHeight / 2
	self.grounded = false
	
	self.jumpYVelocityLeftToApply = 0 -- Velocity remaining to be applied to the jump
	self.jumpTimeLeft = 0 -- Time left for the jump
	
    return self
end

function Hero:getBounds()
	local extent = vec2(16, 16)
	return aabb(self.pos - extent, self.pos + extent)
end

function Hero:move(movement)
	self.velocity.x = movement.x
end

function Hero:handleCollision(collisionInfo)
	-- exclude this contact if it is separating
	if self.velocity:dot(collisionInfo.normal) > 0 then
		return
	end
	
	self.pos = self.pos + collisionInfo.normal * collisionInfo.depth
	
	-- keep only tangent velocity
	local normalVelocity = collisionInfo.normal * self.velocity:dot(collisionInfo.normal)
	self.velocity = self.velocity - normalVelocity
	
	-- check if we collided with the ground
	if -collisionInfo.normal.y > math.abs(collisionInfo.normal.x) then
		self.grounded = true
	end
end

function Hero:update(dt)
	-- reset grounded state
	self.grounded = false
	
	-- gravity!
	self.velocity = self.velocity + Config.gravity * dt
	
	-- position update
	self.pos = self.pos + self.velocity * dt
	
	-- ground hack
	if (self.pos.y) >= self.groundPlaneY - 16 then
		self.velocity.y = 0
		self.pos.y = self.groundPlaneY - 16
		self.grounded = true
	end
end

function Hero:jump()
	if not self.grounded then
		return
	end
	
	self.velocity.y = -Config.heroVerticalSpeed
end

function Hero:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("fill", self.pos.x - 16, self.pos.y - 16, 32, 32)
	
	local bounds = self:getBounds()
	bounds:drawDebug(255, 0, 0, 255)
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print(self.pos.y, -150, -150)
end
