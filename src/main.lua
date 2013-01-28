--[[ 
The NoName Fiber Game
Copyright (c) 2012 Aurélien Defossez, Jean-Marie Comets, Anis Benyoub, Rémi Papillié
]]

require("game.Game")
require("game.IntroScene")

function love.load()
	intro = IntroScene.new{}
	game = Game.new{}
	game:start()
end

function love.mousepressed(x, y, button)
	if intro.active and game then
		game:mousePressed(x, y, button)
	end
end

function love.mousereleased(x, y, button)
	if intro.active and game then
		game:mouseReleased(x, y, button)
	end
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
    elseif intro.active then
		intro:keyPressed(key, unicode)
	else
		game:keyPressed(key, unicode)
	end
end

function love.keyreleased(key, unicode)
	if intro.active then
		intro:keyReleased(key, unicode)
	else
		game:keyReleased(key, unicode)
	end
end

function love.update(dt)
	if dt > 0.1 then
		dt = 0.1
	end
	
	if intro.active then
		-- update intro
		intro:update(dt)
		
		-- if the intro is over, start the game
		if intro.active == false then
			-- don't forget to update it, otherwise next draw will crash
			game:update(dt)
		end
		
		return
		
	else
		game:update(dt)
	end
end

function love.draw()
	if intro.active then
		intro:draw()
		return
	else
		game:draw()
	end
end
