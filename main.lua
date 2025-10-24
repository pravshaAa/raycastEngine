require"player"
require"map"
require"raycast"
require"loadTexture"

function love.load()
    love.graphics.setBackgroundColor(0.3,0.3,0.3)
    Player = Player()
    loadTexture()
    CreateMapTable()
end

function love.update(dt)
	
	Player:Walk()
	
	for i, v in ipairs(mapCordTable) do
		if CheckCollision(Player.x, Player.y, Player.width, Player.height, mapCordTable[i].x, mapCordTable[i].y, mapS, mapS) then
			Player.x = Player.oldX
			Player.y = Player.oldY
		end
	end
	
	FPS = love.timer.getFPS()
end

function love.draw()
	love.graphics.setColor(0.4,0.4,0.4)
	love.graphics.rectangle("fill", 512, 256, 512, 256)
	
	love.graphics.setColor(0.06, 0.73, 0.9) 
	love.graphics.rectangle("fill", 512, 0, 512, 256)
	
	DrawRays3D()
	MapDraw()
	Player:Draw()
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("FPS:"..tostring(FPS), 10, 20)
end
