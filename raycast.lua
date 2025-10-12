require"player"
require"map"

local DR = 0.0174533

function DrawRays3D()
    local ra = Player.a - DR * 30  
    
    for r = 1, 60 do
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
            ryH = (math.floor(Player.y / 64) * 64) - 0.0001
            rxH = (Player.y - ryH) * aTan + Player.x
            yoH = -64
            xoH = -yoH * aTan
        elseif ra < math.pi then -- Вниз
            ryH = (math.floor(Player.y / 64) * 64) + 64
            rxH = (Player.y - ryH) * aTan + Player.x
            yoH = 64
            xoH = -yoH * aTan
        else
            rxH = Player.x
            ryH = Player.y
            dofH = 8
        end
        
        while dofH < 8 do
            local mx = math.floor(rxH / 64)
            local my = math.floor(ryH / 64)
            local mp = my * mapX + mx + 1
            
            if mp > 0 and mp <= mapX * mapY and map[mp] == 1 then
                hRx = rxH
                hRy = ryH
                hHit = true
                hDist = math.sqrt((Player.x - hRx)^2 + (Player.y - hRy)^2)
                dofH = 8
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
            rxV = (math.floor(Player.x / 64) * 64) - 0.0001
            ryV = (Player.x - rxV) * nTan + Player.y
            xoV = -64
            yoV = -xoV * nTan
        elseif ra < math.pi/2 or ra > 3*math.pi/2 then -- Право
            rxV = (math.floor(Player.x / 64) * 64) + 64
            ryV = (Player.x - rxV) * nTan + Player.y
            xoV = 64
            yoV = -xoV * nTan
        end
        
        if ra == 0 or ra == math.pi then
            rxV = Player.x
            ryV = Player.y
            dofV = 8
        end
        
        while dofV < 8 do
            local mx = math.floor(rxV / 64)
            local my = math.floor(ryV / 64)
            local mp = my * mapX + mx + 1
            
            if mp > 0 and mp <= mapX * mapY and map[mp] == 1 then
                vRx = rxV
                vRy = ryV
                vHit = true
                vDist = math.sqrt((Player.x - vRx)^2 + (Player.y - vRy)^2)
                dofV = 8
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
            finalRx = Player.x + math.cos(ra) * 500
            finalRy = Player.y + math.sin(ra) * 500
            finalDist = 500
            wallColor = {0.8, 0.8, 0.8}
        end
        
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(1)
        love.graphics.line(Player.x + Player.width/2, Player.y + Player.height/2, 
                          finalRx, finalRy)
        
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
        
        local lineH = (mapS * 512) / finalDist
        local lineO = 256 - lineH / 2
        
        if lineH > 1024 then 
            lineH = 1024 
			lineO = 256 - 512
        end
        
        local lineX = r * (512 / 60)
        love.graphics.setColor(wallColor[1], wallColor[2], wallColor[3])
        love.graphics.setLineWidth(512 / 60 + 0.5)
        love.graphics.line(lineX + 512, lineO, lineX + 512, lineH + lineO)
        
        ra = ra + DR
    end
end
