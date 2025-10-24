require"player"
require"map"
require"loadTexture"

local XRender3D = 512
local Width3D = 512
local FOV = 60
local Height3D = 512
local MapTileSize = mapS
local MaxLength = 500
local detail = 2

local DR = 0.0174533 / detail
local HalfHeight3D = Height3D / 2
local LineWidth = Width3D / FOV / detail + 0.5
local MaxDof = math.max(mapX, mapY)

local textureSize = 64
local wallColor = {}

function DrawRays3D()
	local PlayerXcenter = Player.x + Player.width/2
	local PlayerYcenter = Player.y + Player.height/2
    local ra = Player.a - DR * (FOV/2) * detail
    
    for r = 1, FOV * detail do
        if ra < 0 then
            ra = ra + 2 * math.pi
        end
        
        if ra > 2 * math.pi then
            ra = ra - 2 * math.pi
        end
        
        local hRx, hRy, vRx, vRy = 0, 0, 0, 0
        local hHit, vHit = false, false
        local hDist, vDist = math.huge, math.huge
        local hWallType, vWallType = 0, 0
        
        -- Горизонтальные проверки
        local dofH = 0
        local aTan = -1 / math.tan(ra)
        local rxH, ryH, xoH, yoH = 0, 0, 0, 0
        
        if ra > math.pi then -- Вверх
            ryH = (math.floor(PlayerYcenter / MapTileSize) * MapTileSize) - 0.0001
            rxH = (PlayerYcenter - ryH) * aTan + PlayerXcenter
            yoH = -MapTileSize
            xoH = -yoH * aTan
        elseif ra < math.pi then -- Вниз
            ryH = (math.floor(PlayerYcenter / MapTileSize) * MapTileSize) + MapTileSize
            rxH = (PlayerYcenter - ryH) * aTan + PlayerXcenter
            yoH = MapTileSize
            xoH = -yoH * aTan
        else
            rxH = PlayerXcenter
            ryH = PlayerYcenter
            dofH = MaxDof
        end
        
        while dofH < MaxDof do
            local mx = math.floor(rxH / MapTileSize)
            local my = math.floor(ryH / MapTileSize)
            local mp = my * mapX + mx + 1
            
            if mp > 0 and mp <= mapX * mapY and map[mp] ~= 0 then
                hRx = rxH
                hRy = ryH
                hHit = true
                hWallType = map[mp]
                hDist = math.sqrt((PlayerXcenter - hRx)^2 + (PlayerYcenter - hRy)^2)
                dofH = MaxDof
            else
                rxH = rxH + xoH
                ryH = ryH + yoH
                dofH = dofH + 1
            end
        end
        
        -- Вертикальные проверки
        local dofV = 0
        local nTan = -math.tan(ra)
        local rxV, ryV, xoV, yoV = 0, 0, 0, 0
        
        if ra > math.pi/2 and ra < 3*math.pi/2 then -- Лево
            rxV = (math.floor(PlayerXcenter / MapTileSize) * MapTileSize) - 0.0001
            ryV = (PlayerXcenter - rxV) * nTan + PlayerYcenter
            xoV = -MapTileSize
            yoV = -xoV * nTan
        elseif ra < math.pi/2 or ra > 3*math.pi/2 then -- Право
            rxV = (math.floor(PlayerXcenter / MapTileSize) * MapTileSize) + MapTileSize
            ryV = (PlayerXcenter - rxV) * nTan + PlayerYcenter
            xoV = MapTileSize
            yoV = -xoV * nTan
        else
            rxV = PlayerXcenter
            ryV = PlayerYcenter
            dofV = MaxDof
        end
        
        while dofV < MaxDof do
            local mx = math.floor(rxV / MapTileSize)
            local my = math.floor(ryV / MapTileSize)
            local mp = my * mapX + mx + 1
            
            if mp > 0 and mp <= mapX * mapY and map[mp] ~= 0 then
                vRx = rxV
                vRy = ryV
                vHit = true
                vWallType = map[mp]
                vDist = math.sqrt((PlayerXcenter - vRx)^2 + (PlayerYcenter - vRy)^2)
                dofV = MaxDof
            else
                rxV = rxV + xoV
                ryV = ryV + yoV
                dofV = dofV + 1
            end
        end
        
        local finalRx, finalRy, finalDist
        local wallType = 1
        local isVerticalHit = false
        local wallX -- Координата X на текстуре
        
        if hHit and vHit then
            if hDist < vDist then
                finalRx, finalRy, finalDist = hRx, hRy, hDist
                wallType = hWallType
                wallX = finalRx % MapTileSize
            else
                finalRx, finalRy, finalDist = vRx, vRy, vDist
                wallType = vWallType
                isVerticalHit = true
                wallX = finalRy % MapTileSize
            end
        elseif hHit then
            finalRx, finalRy, finalDist = hRx, hRy, hDist
            wallType = hWallType
            wallX = finalRx % MapTileSize
        elseif vHit then
            finalRx, finalRy, finalDist = vRx, vRy, vDist
            wallType = vWallType
            isVerticalHit = true
            wallX = finalRy % MapTileSize
        else
            finalDist = MaxLength
        end
        
		--Отрисовка лучей (2д вид)
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(1)
        love.graphics.line(
            Player.x + Player.width/2, 
            Player.y + Player.height/2, 
            finalRx, 
            finalRy
        )
        
        -- 3д сцена
        local ca = Player.a - ra
        
        if ca < 0 then
            ca = ca + 2 * math.pi
        end
        
        if ca > 2 * math.pi then
            ca = ca - 2 * math.pi
        end
        
        finalDist = finalDist * math.cos(ca)
        
        if finalDist < 1 then
            finalDist = 1
        end
        
        local lineH = (MapTileSize * XRender3D) / finalDist
        local lineO = HalfHeight3D - lineH / 2
        
        if lineH > Height3D * 2 then 
            lineH = Height3D * 2
            lineO = HalfHeight3D - Height3D
        end
        
        local lineX = r * (Width3D / (FOV * detail))
        
        if wallTextures[wallType] and finalDist < MaxLength then
            local texX = math.floor((wallX / MapTileSize) * textureSize)
            if texX < 0 then texX = 0 end
            if texX >= textureSize then texX = textureSize - 1 end
            
            if isVerticalHit then
                wallColor = {0.75, 0.75, 0.75}
			else
				wallColor = {1, 1, 1}
            end
            
            love.graphics.setColor(wallColor[1], wallColor[2], wallColor[3])
            
            love.graphics.draw(
                wallTextures[wallType],
                love.graphics.newQuad(
                    texX, 0, 1, textureSize,
                    textureSize, textureSize
                ),
                lineX + XRender3D - LineWidth/2,
                lineO,
                0,
                LineWidth,
                lineH / textureSize
            )
        else 
            --love.graphics.setColor(1,1,1)
            --love.graphics.setLineWidth(LineWidth)
            --love.graphics.line(
            --    lineX + XRender3D, 
            --    lineO, 
            --    lineX + XRender3D, 
            --    lineH + lineO
            --)
        end
        
        ra = ra + DR
    end
end
