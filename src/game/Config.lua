--[[ 

]]

require("math.vec2")
require("math.vec4")

Config = {
	-- Intro configuration

	-- Game space configuration 
	virtualScreenHeight = 1080,
	spriteScale = 2,
	
	-- Gameplay configuration
	maxHeartWorth = 3, -- How much hearts the player is worth (max)
	levelDuration = 60,
	
	-- Text blocks
	textBlockDurationOnScreen = 7, -- in seconds
	textBlockSpawnDuration = 0.5, -- in seconds
	textBlockScrollSpeedAdjustmentMax = 7, -- in pixel/s, maximum adjustment speed to give to text blocks when the camera is at its maximum speed
	textBlockShakeAmplitudeMax = 10,
	textBlockShakeSpeed = 3,
	
	-- Player avatar configuration
	heroHorizontalSpeed = vec2(400,0), -- How much the hero moves when it's walking to the right (px/s)
	heroVerticalSpeed = 1000, -- How much the hero moves when it's jumping upwards (px/s)
	heroJumpDuration = 1, -- How long does the ascending part of the jump last, in seconds
	gravity = vec2(0, 2000), -- Strenght of the gravity
	floatingSpeed = vec2(300, 100),
	
	-- Background
	bgPulseColorAmplitude = 10, -- How much the color pulses, in color space.
	bgPulseColorSpeed = 3, -- How many pulses per second (full circle).
	
	-- Blocks
	blockWidth = 128,
	blockWidthVariation = 64,
	blockHeight = 350,
	blockHeightVariation = 200,
	blockColorVariation = 15,
	blockAnimSpeed = 3,
	blockAnimSize = 10,
	blockBase = 600,
	blockSpacing = 10,
	
	-- Base colors
	boredColor = vec4(21, 19, 101, 255),
	excitedColor = vec4(220, 16, 20, 255),
	--boredColor = vec4(10, 10, 10, 255),
	--excitedColor = vec4(240, 240, 240, 255),
	cBlank = vec4(0,0,0,255),
	cLight = vec4(250, 245, 250 ,255),
	
	-- Camera
	cameraShakeAmplitude = 20,
	cameraShakeSpeed = 3,
	cameraScrollSpeedMin = 300,
	cameraScrollSpeedMax = 700,
	
	-- Sound
	soundFadeDuration = 8,

	-- Inactivity timer
	inacTimerOn = false,
	inacTimerStart = 30 -- How long the game needs to be inactive before it is reset, in seconds
}
