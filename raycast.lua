require"player"
require"map"

local XRender3D = 512
local Width3D = 512
local FOV = 60
local Height3D = 512
local MapTileSize = 64
local MaxLength = 500
local detail = 5

local DR = 0.0174533 / detail
local HalfHeight3D = Height3D / 2
local LineWidth = Width3D / FOV / detail + 0.5
local MaxDof = math.max(mapX, mapY)

function DrawRays3D()
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
        
        -- Горизонтальные проверки
        local dofH = 0
        local aTan = -1 / math.tan(ra)
        local rxH, ryH, xoH, yoH = 0, 0, 0, 0
        
        if ra > math.pi then -- Вверх
            ryH = (math.floor(Player.y / MapTileSize) * MapTileSize) - 0.0001
            rxH = (Player.y - ryH) * aTan + Player.x
            yoH = -MapTileSize
            xoH = -yoH * aTan
        elseif ra < math.pi then -- Вниз
            ryH = (math.floor(Player.y / MapTileSize) * MapTileSize) + MapTileSize
            rxH = (Player.y - ryH) * aTan + Player.x
            yoH = MapTileSize
            xoH = -yoH * aTan
        else
            rxH = Player.x
            ryH = Player.y
            dofH = MaxDof
        end
        
        while dofH < MaxDof do
            local mx = math.floor(rxH / MapTileSize)
            local my = math.floor(ryH / MapTileSize)
            local mp = my * mapX + mx + 1
            
            if mp > 0 and mp <= mapX * mapY and map[mp] == 1 then
                hRx = rxH
                hRy = ryH
                hHit = true
                hDist = math.sqrt((Player.x - hRx)^2 + (Player.y - hRy)^2)
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
            rxV = (math.floor(Player.x / MapTileSize) * MapTileSize) - 0.0001
            ryV = (Player.x - rxV) * nTan + Player.y
            xoV = -MapTileSize
            yoV = -xoV * nTan
        elseif ra < math.pi/2 or ra > 3*math.pi/2 then -- Право
            rxV = (math.floor(Player.x / MapTileSize) * MapTileSize) + MapTileSize
            ryV = (Player.x - rxV) * nTan + Player.y
            xoV = MapTileSize
            yoV = -xoV * nTan
        end
        
        if ra == 0 or ra == math.pi then
            rxV = Player.x
            ryV = Player.y
            dofV = MaxDof
        end
        
        while dofV < MaxDof do
            local mx = math.floor(rxV / MapTileSize)
            local my = math.floor(ryV / MapTileSize)
            local mp = my * mapX + mx + 1
            
            if mp > 0 and mp <= mapX * mapY and map[mp] == 1 then
                vRx = rxV
                vRy = ryV
                vHit = true
                vDist = math.sqrt((Player.x - vRx)^2 + (Player.y - vRy)^2)
                dofV = MaxDof
            else
                rxV = rxV + xoV
                ryV = ryV + yoV
                dofV = dofV + 1
            end
        end
        
        local finalRx, finalRy, finalDist
        local wallColor = {0.8, 0.8, 0.8}
        
        if hHit and vHit then
            if hDist < vDist then
                finalRx, finalRy, finalDist = hRx, hRy, hDist
                wallColor = {0.8, 0.8, 0.8}
            else
                finalRx, finalRy, finalDist = vRx, vRy, vDist
                wallColor = {0.6, 0.6, 0.6}
            end
        elseif hHit then
            finalRx, finalRy, finalDist = hRx, hRy, hDist
            wallColor = {0.8, 0.8, 0.8}
        elseif vHit then
            finalRx, finalRy, finalDist = vRx, vRy, vDist
            wallColor = {0.6, 0.6, 0.6}
        else
            finalRx = Player.x + math.cos(ra) * MaxLength
            finalRy = Player.y + math.sin(ra) * MaxLength
            finalDist = MaxLength
            wallColor = {0.8, 0.8, 0.8}
        end
        
        -- Отрисовка лучей (2д вид)
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
        
        -- Отрисовка 3д стены
        love.graphics.setColor(wallColor[1], wallColor[2], wallColor[3])
        love.graphics.setLineWidth(LineWidth)
        love.graphics.line(
            lineX + XRender3D, 
            lineO, 
            lineX + XRender3D, 
            lineH + lineO
        )
        
        ra = ra + DR
    end
end
