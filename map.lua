mapX=8
mapY=24
mapS=64
mapCordTable = {}

map = {
	1,3,4,3,4,3,1,1,
	3,0,0,0,0,0,0,1,
	4,0,0,0,3,0,0,1,
	3,0,2,0,1,0,0,1,
	1,0,0,0,0,0,0,1,
	1,0,1,0,1,1,0,1,
	1,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,1,
	1,0,0,0,1,0,0,1,
	1,0,1,0,1,0,0,1,
	1,0,0,0,0,0,0,1,
	1,0,1,0,1,1,0,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,0,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,
}

function CreateMapTable()
    mapCordTable = {}
    local levelMapY = 0
    local lastX = -mapS
    for i = 1,mapX*mapY do
        lastX = lastX + mapS
        if map[i] ~= 0 then
            table.insert(mapCordTable, {x=lastX, y=levelMapY})
        end
        if i % mapX == 0 then
            lastX = -mapS
            levelMapY = levelMapY + mapS
        end
    end
end

function MapDraw()
    for i, v in ipairs(mapCordTable) do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", v.x, v.y, mapS, mapS)
    end
end
