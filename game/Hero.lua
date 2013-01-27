--[[ 

]]

require("math.aabb")
require("math.vec2")

local anim8 = require("lib.anim8")

Hero = {}
Hero.__index = Hero

function Hero.new(options)
    local self = {}
    setmetatable(self, Hero)
	
	self.pos = vec2(0,0)
	self.velocity = vec2(0,0)
	self.groundPlaneY = Config.virtualScreenHeight / 2
	self.grounded = false
	self.image = love.graphics.newImage("assets/bunny/bunny.png")
	self.image:setFilter("nearest", "nearest")
	
	local grid = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
	self.animations = {
		idle = anim8.newAnimation("loop", grid(1, 2), 0.2),
		walk = anim8.newAnimation("loop", grid(1, 1, 2, 1), 0.2),
		jump = anim8.newAnimation("once", grid(1, 3, 2, 3, 3, 3), 0.2),
		fall = anim8.newAnimation("loop", grid(4, 3), 0.2),
		float = anim8.newAnimation("loop", grid(1, 4, 2, 4), 0.2)
	}
	self:playAnimation("idle")
	self.animationSide = 1
	
    return self
end

function Hero:getBounds()
	local extent = vec2(16, 16) * Config.rabbitScale
	return aabb(self.pos - extent, self.pos + extent)
end

function Hero:move(movement)
	self.velocity.x = movement.x
	
	-- check if we need to flip the animations
	if self.animationSide * movement.x < 0 then
		self.animationSide = movement.x
		
		for _, anim in pairs(self.animations) do
			anim:flipH()
		end
	end
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
		return true -- signal ground collision to game, for block interaction
	end
	
	return false
end

function Hero:playAnimation(name)
	local anim = self.animations[name]
	if not (self.currentAnimation == anim) then
		self.currentAnimation = self.animations[name]
		self.currentAnimation:gotoFrame(1)
		self.currentAnimation:resume()
	end
end

function Hero:update(dt)
	-- animation state
	if self.grounded then
		if math.abs(self.velocity.x) > 0 then
			self:playAnimation("walk")
		else
			self:playAnimation("idle")
		end
	else
		if self.velocity.y < 0 then
			self:playAnimation("jump")
		else
			self:playAnimation("fall")
		end
	end
	
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
	
	self.currentAnimation:update(dt)
end

function Hero:jump()
	if not self.grounded then
		return
	end
	
	self.velocity.y = -Config.heroVerticalSpeed
end

function Hero:draw()
	love.graphics.setColor(255, 255, 255, 255)
	local headPosition = vec2(48, 48)
	if self.animationSide < 0 then
		headPosition = vec2(16, 48)
	end
	self.currentAnimation:draw(self.image, self.pos.x, self.pos.y, 0, Config.rabbitScale, Config.rabbitScale, headPosition.x, headPosition.y)
	
	--local bounds = self:getBounds()
	--bounds:drawDebug(255, 0, 0, 255)
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print(self.pos.y, -150, -150)
end
