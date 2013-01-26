--[[ 

]]

require("math.vec2")
require("math.vec4")

Config = {
	-- Game space configuration 
	virtualScreenHeight = 1080,
	
	-- Player avatar configuration
	heroHorizontalSpeed = vec2(500,0), -- How much the hero moves when it's walking to the right (px/s)
	heroVerticalSpeed = 1000, -- How much the hero moves when it's jumping upwards (px/s)
	heroJumpDuration = 1, -- How long does the ascending part of the jump last, in seconds
	gravity = vec2(0, 2000), -- Strenght of the gravity
	rabbitScale = 2,
	
	-- Background
	bgPulseColorAmplitude = 10, -- How much the color pulses, in color space.
	bgPulseColorSpeed = 3, -- How many pulses per second (full circle).
	
	-- Blocks
	blockWidth = 120,
	blockWidthVariation = 100,
	blockHeight = 350,
	blockHeightVariation = 200,
	blockColorVariation = 0.2,
	blockBase = 600,
	
	-- Scrolling
	scrollSpeed = 300,
	
	-- Base colors
	boredColor = vec4(21, 19, 101, 255),
	excitedColor = vec4(220, 16, 20, 255),
	cBlank = {0,0,0,255},
	
	-- Camera
	cameraShakeAmplitude = 20,
	cameraShakeSpeed = 3
}
