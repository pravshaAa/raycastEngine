require"player"
require"map"
require"raycast"

function love.load()
	love.graphics.setBackgroundColor(0.3,0.3,0.3)--(0.06, 0.73, 0.9)  
	Player = Player()
end

function love.update(dt)
	
	Player:Walk()
	
	for i, v in ipairs(mapCordTable) do
		if CheckCollision(Player.x, Player.y, Player.width, Player.height, mapCordTable[i].x, mapCordTable[i].y, mapS, mapS) then
			Player.x = Player.oldX
			Player.y = Player.oldY
		end
	end
end

function love.draw()
	DrawRays3D()
	MapDraw()
	Player:Draw()
end

