
require("game.Game")
require("game.IntroScene")
require("game.GameOverScene")
require("game.LoaderSplashScene")

function love.load()
	loader = LoaderSplashScene.new{}
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
	elseif loader.complete == false then
		loader:keyPressed(key, unicode)
    elseif intro.active then
		intro:keyPressed(key, unicode)
	elseif game.isGameOver then
		outro:keyPressed(key, unicode)
	else
		game:keyPressed(key, unicode)
	end
end

function love.keyreleased(key, unicode)
	if loader.complete == false then
		loader:keyReleased(key, unicode)
	elseif intro.active then
		intro:keyReleased(key, unicode)
	elseif game.isGameOver then
		outro:keyReleased(key, unicode)
	else
		game:keyReleased(key, unicode)
	end
end

function love.update(dt)
	if dt > 0.1 then
		dt = 0.1
	end
	
	if loader.completed == false then
		-- update loader
		loader:update(dt)

		-- if the loader is complete, start the intro
		if loader.completed == true then
			-- gets the scenes from the loader
			intro = loader.loadedResources.intro
			game = loader.loadedResources.game
			outro = loader.loadedResources.outro
			
			-- starts the game
			game:start()
			
			-- updates the intro
			intro:update(dt)
		end
	elseif intro.active then
		
		-- update intro
		intro:update(dt)
		
		-- if the intro is over, start the game
		if intro.active == false then
			-- don't forget to update it, otherwise next draw will crash
			game:update(dt)
		end
		
	elseif game.isGameOver then
		-- updates outro
		outro:update(dt)
		
		-- if the outro is over, restart the intro
		if outro.active == false then
			-- reset game
			game:start()
			
			-- restart intro
			intro:restart()
			intro:update(dt)
		end
	else
		game:update(dt)
	end
end

function love.draw()
	if loader.completed == false then
		loader:draw()
	elseif intro.active then
		intro:draw()
	elseif game.isGameOver then
		outro:draw()
	else
		game:draw()
	end
end
