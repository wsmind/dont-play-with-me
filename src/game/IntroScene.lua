
require("game.Config")

IntroScene = {}
IntroScene.__index = IntroScene

function IntroScene.new(options)
    local self = {}
    setmetatable(self, IntroScene)
	
	-- the game has a virtual height
	self.virtualScreenHeight = Config.virtualScreenHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	self.virtualScreenWidth = self.screenRatio * self.virtualScreenHeight
	
	self.pages = {
		love.graphics.newImage("assets/intro/Page01.png"),
		love.graphics.newImage("assets/intro/Page02.png"),
		love.graphics.newImage("assets/intro/Page03.png"),
		love.graphics.newImage("assets/intro/Page04.png")
	}
	
	for _,v in ipairs(self.pages) do
		v:setFilter("nearest","nearest")
	end
	
	self.pageScale = 1
	
	self.currentPage = 1
	self.currentPageSource = nil
	self.currentPageWidth = 0
	self.currentPageHeight = 0
	self.currentPageScaleX = 0
	self.currentPageScaleY = 0
	self:updateCurrentPage()
	
	-- inactivity timer
	self.elapsedInactivityTime = 0

	self.active = true

	
    return self
end

function IntroScene:restart()
	love.graphics.setColor({255, 255, 255, 255})
	
	self.currentPage = 1
	self:updateCurrentPage()
	
	self.active = true
end

function IntroScene:keyPressed(key, unicode)
	self.currentPage = self.currentPage + 1
	self:updateCurrentPage()
	
	-- inactivity reset
	self.elapsedInactivityTime = 0
end

function IntroScene:updateCurrentPage()
	if self.currentPage > #self.pages then
		self.active = false
		return
	end
	
	self.currentPageSource = self.pages[self.currentPage]
	self.currentPageWidth = self.currentPageSource:getWidth()
	self.currentPageHeight = self.currentPageSource:getHeight()
	self.currentPageScaleY = 1 --love.graphics.getHeight() / self.currentPageHeight
	self.currentPageScaleX = self.currentPageScaleY
	--self.currentPageScaleY = love.graphics.getWidth() / self.currentPageWidth
	--self.currentPageScaleX = currentPageScaleY
end

function IntroScene:keyReleased(key, unicode)
	-- inactivity reset
	self.elapsedInactivityTime = 0
end

function IntroScene:update(dt)
	-- update inactivity timer
	self.elapsedInactivityTime = self.elapsedInactivityTime + dt
	
	-- check inactivity
	if Config.inacTimerOn and self.elapsedInactivityTime > Config.inacTimerStart then
		-- reset to first page
		self.currentPage = 1
		self:updateCurrentPage()
		
		-- reset inactivity
		self.elapsedInactivityTime = 0
	end
end

function IntroScene:draw()
	if self.currentPage > #self.pages then
		return
	end
	
	-- background
	love.graphics.draw(self.currentPageSource, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, self.currentPageScaleX, self.currentPageScaleY, self.currentPageWidth / 2, self.currentPageHeight / 2)
	
	-- text
	--love.graphics.setColor(Config.cLight:asTable())
	--love.graphics.print("Press any key.", self.virtualScreenWidth / 2 - 100, self.virtualScreenHeight / 3)
end