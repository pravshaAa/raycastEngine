mapX=8
mapY=8
mapS=64
mapCordTable = {}

map = {
	1,1,1,1,1,1,1,1,
	1,0,0,0,0,0,0,1,
	1,0,0,0,1,0,0,1,
	1,0,1,0,1,0,0,1,
	1,0,0,0,0,0,0,1,
	1,0,1,0,1,1,0,1,
	1,0,0,0,0,0,0,1,
	1,1,1,1,1,1,1,1
}

function MapDraw()
	local levelMapY = 0
	local lastX = -mapS
	for i = 1,mapX*mapY do
		lastX = lastX + mapS
		if map[i] == 1 then
			love.graphics.setColor(1,1,1)
			love.graphics.rectangle("fill", lastX, levelMapY, mapS, mapS)
			table.insert(mapCordTable, {x=lastX, y=levelMapY})
		end
		if i % mapX == 0 then
			lastX = -mapS
			levelMapY = levelMapY + mapS
		end
	end
end
