--[[ 

]]

require("math.vec4")
require("game.Config")

Background = {}
Background.__index = Background

function Background.new(options)
    local self = {}
    setmetatable(self, Background)
	
	self.mood = options.mood
	
	self.color = self.mood:getColorVec4()
	self.pulseDuration = 2
	self.pulseBreakDuration = 1
	
	self.currentTime = 0
	self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	
	self.nextBreakTime = 5
	
	self.image = love.graphics.newImage("assets/background/Gradient.png")
	self.image:setFilter("nearest","nearest")
	self.imageScaleY = love.graphics.getHeight() / self.image:getHeight()
	self.imageScaleX = love.graphics.getWidth() / self.image:getWidth()
	
    return self
end

function Background:update(dt)
	self.currentTime = self.currentTime + dt
	
	-- updates the pulse parameters according to mood.
	self.pulseBreakDuration = 5 * (1 - self.mood.excitement) + 0.5
	
	-- pulses the background color
	local baseColor = self.mood:getColorVec4()
	local shift = math.sin(self.currentTime * Config.bgPulseColorSpeed) * Config.bgPulseColorAmplitude -- gets the color shift
	baseColor = (baseColor + vec4(shift, shift, shift, shift)):clamp(0, 255) -- shiffted color
	local finalFactor = math.exp(-math.fmod(self.currentTime, self.pulseBreakDuration)) * self.pulseDuration -- break and shift factor
	baseColor = baseColor * finalFactor -- shiffted color + breaks
	self.color = baseColor
	--self.color = self.mood:getColorVec4()
end

function Background:draw()
	-- set color
	love.graphics.setColor(self.color:asTable())
	
	-- set color mode
	love.graphics.setColorMode("modulate")
	
	--love.graphics.rectangle("fill", 0, 0, Config.virtualScreenHeight * self.screenRatio, Config.virtualScreenHeight)
	love.graphics.draw(self.image, 0, 0, 0, self.imageScaleX, self.imageScaleY)
	--love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
end