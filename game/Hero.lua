--[[ 

]]

require("math.vec2")

Hero = {}
Hero.__index = Hero

function Hero.new(options)
    local self = {}
    setmetatable(self, Hero)
	
	self.pos = vec2(0,0)
	self.velocity = vec2(0,0)
	self.groundPlaneY = Config.virtualScreenHeight / 3
	
	self.jumpYVelocityLeftToApply = 0 -- Velocity remaining to be applied to the jump
	
    return self
end

function Hero:move(movement)
	self.velocity.x = movement.x
end

function Hero:jump(movement)
	if not self:isOnGround() then 
		return
	end

	-- registers the new jump velocity
	self.jumpYVelocityLeftToApply = movement.y
end

function Hero:update(dt)
	
	-- gravity!
	if not self:isOnGround() then
		-- adds gravity to the velocity
		self.velocity = self.velocity + Config.gravity * dt
	else
		-- we reached the ground: no more gravity
		self.velocity.y = 0
		self.pos.y = self.groundPlaneY
	end
	
	-- jump!
	if self.jumpYVelocityLeftToApply ~= 0 then
		self.velocity.y = self.velocity.y + self.jumpYVelocityLeftToApply
		self.jumpYVelocityLeftToApply = 0
	end
	
	-- position update
	self.pos = self.pos + self.velocity * dt
end

function Hero:draw()
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 60, 120)
	
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print(self.pos.y, -150, -150)
end

function Hero:isOnGround()
	return self.pos.y >= self.groundPlaneY
	
	--todo: on est en collision sur une surface horizontale
end