--[[ 

]]

require("math.vec2")

Config = {
	-- Game space configuration 
	virtualScreenHeight = 1080,
	
	-- Player avatar configuration
	heroHorizontalSpeed = vec2(500,0), -- How much the hero moves when it's walking to the right (px/s)
	heroVerticalSpeed = vec2(0,-500), -- How much the hero moves when it's jumping upwards (px/s)
	heroJumpDuration = 1, -- How long does the ascending part of the jump last, in seconds
	gravity = vec2(0,1000) -- Strenght of the gravity
}