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
	self.image = love.graphics.newImage("assets/bunny/Spritesheet.png")
	self.image:setFilter("nearest", "nearest")
	
	local grid = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())
	self.anim = anim8.newAnimation("loop", grid(1,1, 1,2, 1,3, 2,3, 3,3), 0.2)
	
    return self
end

function Hero:getBounds()
	local extent = vec2(16, 16) * Config.rabbitScale
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
		return true -- signal ground collision to game, for block interaction
	end
	
	return false
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
	
	self.anim:update(dt)
end

function Hero:jump()
	if not self.grounded then
		return
	end
	
	self.velocity.y = -Config.heroVerticalSpeed
end

function Hero:draw()
	--love.graphics.rectangle("fill", self.pos.x - 16, self.pos.y - 16, 32, 32)
	love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.draw(self.image, self.pos.x - 16 * Config.rabbitScale, self.pos.y - 16 * Config.rabbitScale, 0, Config.rabbitScale, Config.rabbitScale)
	self.anim:draw(self.image, self.pos.x, self.pos.y, 0, Config.rabbitScale, Config.rabbitScale, 48, 48)
	
	--local bounds = self:getBounds()
	--bounds:drawDebug(255, 0, 0, 255)
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print(self.pos.y, -150, -150)
end
