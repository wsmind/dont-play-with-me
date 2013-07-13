
require("game.Game")
require("game.IntroScene")
require("game.GameOverScene")

LoaderSplashScene = {}
LoaderSplashScene.__index = LoaderSplashScene

function LoaderSplashScene.new(options)
    local self = {}
    setmetatable(self, LoaderSplashScene)
	
	-- sets color and background
	love.graphics.setBackgroundColor(0,0,0,255)
	love.graphics.setColor({255,255,255,255})
	
	-- loads font
	self.font = love.graphics.newFont("assets/fonts/Dimbo Regular.ttf",40)
	love.graphics.setFont(self.font)
	
	-- the game has a virtual height
	self.screenWidth = love.graphics.getWidth()
	self.screenHeight = love.graphics.getHeight()
	
	-- loading state
	-- "none" : the splash needs to be init
	-- "loading" : the splash is onscreen, and the game is loading
	-- "ingame" : the game is shown
	self.loadingState = "none"
	
	-- things to load
	self.loadedResources = {
		intro = nil,
		game = nil,
		outro = nil
	}
	
	self.completed = false

    return self
end

function LoaderSplashScene:keyPressed(key, unicode)

end

function LoaderSplashScene:keyReleased(key, unicode)
	
end

function LoaderSplashScene:update(dt)
	-- updates the state
	if self.loadingState == "none" then
		
		-- start loading next time.
		self.loadingState = "loading"

	elseif self.loadingState == "loading" then

		-- start loading
		self.loadedResources.intro = IntroScene.new{}
		self.loadedResources.outro = GameOverScene.new{}
		self.loadedResources.game = Game.new{
			gameOverScene = self.loadedResources.outro
		}
		
		-- marks the loading as complete
		self.loadingState = "ingame"
		self.completed = true
	end
	
	
end

function LoaderSplashScene:draw()
	-- draws splash
	if self.completed == false then
		love.graphics.print("LOADING...", self.screenWidth / 2 - 80, self.screenHeight / 2 - 40)
	end
end