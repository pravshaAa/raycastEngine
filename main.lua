require"player"
require"map"
require"raycast"

function love.load()
	love.graphics.setBackgroundColor(0.3,0.3,0.3)--(0.06, 0.73, 0.9)
	Player = Player()
end

function love.update(dt)
	Player:Walk()
end

function love.draw()
	DrawRays3D()
	MapDraw()
	Player:Draw()
end
