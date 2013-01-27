
require("game.Config")

IntroScene = {}
IntroScene.__index = IntroScene

function IntroScene.new(options)
    local self = {}
    setmetatable(self, IntroScene)
	
	self.pages = {
		love.graphics.newImage("assets/intro/Page01.png"),
		love.graphics.newImage("assets/intro/Page02.png"),
		love.graphics.newImage("assets/intro/Page03.png")
	}
	
	self.currentPage = 1
	self.currentPageSource = nil
	self.currentPageWidth = 0
	self.currentPageHeight = 0
	self:updateCurrentPage()

	self.active = true
	
	-- the game has a virtual height
	self.virtualScreenHeight = Config.virtualScreenHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	self.virtualScreenWidth = self.screenRatio * self.virtualScreenHeight
	
    return self
end

function IntroScene:getIsOver()
	return not self.active
end

function IntroScene:keyPressed(key, unicode)
	self.currentPage = self.currentPage + 1
	self:updateCurrentPage()
end

function IntroScene:updateCurrentPage()
	if self.currentPage > #self.pages then
		self.active = false
		return
	end
	
	self.currentPageSource = self.pages[self.currentPage]
	self.currentPageWidth = self.currentPageSource:getWidth()
	self.currentPageHeight = self.currentPageSource:getHeight()
end

function IntroScene:keyReleased(key, unicode)
end

function IntroScene:update(dt)
	
end

function IntroScene:draw()
	if self.currentPage > #self.pages then
		return
	end
	
	love.graphics.setColor(Config.cLight:asTable())
	love.graphics.print("Press any key.", self.virtualScreenWidth / 2, self.virtualScreenHeight / 3)
	
	love.graphics.draw(self.currentPageSource, self.virtualScreenWidth / 4, self.virtualScreenHeight / 4, 0, 1, 1, self.currentPageWidth / 2, self.currentPageHeight / 2)

end