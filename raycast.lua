require"player"
require"map"

local DR = 0.0174533

function DrawRays3D()
    local ra = Player.a - DR * 30  
    
    for r = 1, 360 do
        if ra < 0 then
            ra = ra + 2 * math.pi
        end
        
        if ra > 2 * math.pi then
            ra = ra - 2 * math.pi
        end
        
        local hRx, hRy, vRx, vRy = 0, 0, 0, 0
        local hHit, vHit = false, false
        
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
        end
        
        if ra == 0 or ra == math.pi then
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
                dofH = 8
            else
                rxH = rxH + xoH
                ryH = ryH + yoH
                dofH = dofH + 1
            end
        end
	
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
                dofV = 8
            else
                rxV = rxV + xoV
                ryV = ryV + yoV
                dofV = dofV + 1
            end
        end
        
        local finalRx, finalRy
        
        if hHit and vHit then
            local hDist = math.sqrt((Player.x - hRx)^2 + (Player.y - hRy)^2)
            local vDist = math.sqrt((Player.x - vRx)^2 + (Player.y - vRy)^2)
            
            if hDist < vDist then
                finalRx, finalRy = hRx, hRy
            else
                finalRx, finalRy = vRx, vRy
            end
        elseif hHit then
            finalRx, finalRy = hRx, hRy
        elseif vHit then
            finalRx, finalRy = vRx, vRy
        else
            finalRx, finalRy = Player.x + math.cos(ra) * 500, Player.y + math.sin(ra) * 500
        end
        
        love.graphics.setColor(1, 0, 0)
        love.graphics.line(Player.x + Player.width/2, Player.y + Player.height/2, 
        finalRx, finalRy)
        
        ra = ra +  DR
    end
end