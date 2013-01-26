--[[ 

]]

require("math.vec2")

Config = {
	-- Game space configuration 
	virtualScreenHeight = 1080,
	
	-- Player avatar configuration
	heroHorizontalSpeed = vec2(500,0), -- How much the hero moves when it's walking to the right (px/s)
	heroVerticalImpulse = vec2(0,-1000), -- How much the hero moves when it's jumping upwards (px/s)
	gravity = vec2(0,5000) -- Strenght of the gravity
}