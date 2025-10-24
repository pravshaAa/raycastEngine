wallTextures = {}

function loadTexture()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    wallTextures[1] = love.graphics.newImage("sprites/Wall1.png")
    wallTextures[2] = love.graphics.newImage("sprites/Wall2.png") 
    wallTextures[3] = love.graphics.newImage("sprites/Wall3.png")
	wallTextures[4] = love.graphics.newImage("sprites/Wall4.png")
end