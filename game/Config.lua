--[[ 

]]

require("math.vec2")

Config = {
	-- Game space configuration 
	virtualScreenHeight = 1080,
	
	-- Player avatar configuration
	heroHorizontalSpeed = vec2(500,0), -- How much the hero moves when it's walking to the right (px/s)
	heroVerticalSpeed = 1000, -- How much the hero moves when it's jumping upwards (px/s)
	heroJumpDuration = 1, -- How long does the ascending part of the jump last, in seconds
	gravity = vec2(0, 2000), -- Strength of the gravity
	
	-- Blocks
	blockWidth = 120,
	blockWidthVariation = 50,
	blockHeight = 300,
	blockHeightVariation = 100,
	
	-- Background
	bgPulseColorAmplitude = 10, -- How much the color pulses, in color space.
	bgPulseColorSpeed = 3, -- How many pulses per second (full circle).
	
	-- Colors
	cBlank = {0,0,0,255}
	
}
