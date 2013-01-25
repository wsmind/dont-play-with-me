--[[ 
The NoName Fiber Game
Copyright (c) 2012 Aurélien Defossez, Jean-Marie Comets, Anis Benyoub, Rémi Papillié
]]

require("game.Game")

function love.load()
	game = Game.new{}
end

function love.mousepressed(x, y, button)
	game:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	game:mouseReleased(x, y, button)
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
    else
		game:keyPressed(key, unicode)
	end
end

function love.keyreleased(key, unicode)
	game:keyReleased(key, unicode)
end

function love.update(dt)
	if dt > 0.1 then
		dt = 0.1
	end
	
	game:update(dt)
end

function love.draw()
	game:draw()
end
