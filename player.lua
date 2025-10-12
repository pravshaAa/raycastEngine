
function Player()
	
	return {
		x = 92,
		y = 92,
		dX=math.cos(1.5)*2,
		dY=math.sin(1.5)*2,
		a=1.5,
		speed = 2,
		width = 8,
		height = 8,
		
		Walk = function(self, dt)
			if love.keyboard.isDown("w") then
				self.x = self.x + self.dX
				self.y = self.y + self.dY
			elseif love.keyboard.isDown("s") then
				self.x = self.x - self.dX
				self.y = self.y - self.dY
			end
			
			if love.keyboard.isDown("a") then
				self.a = self.a - 0.1
				self.dX = math.cos(self.a)*self.speed
				self.dY = math.sin(self.a)*self.speed
				if self.a < 0 then
					self.a = 2 * math.pi
				end
			elseif love.keyboard.isDown("d") then
				self.a = self.a + 0.1
				self.dX = math.cos(self.a)*self.speed
				self.dY = math.sin(self.a)*self.speed
				if self.a > 2 * math.pi then
					self.a = 0
				end
			end
		end,
		
		Draw = function(self)
			love.graphics.setColor(0.9,0.9,0)
			love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			
			love.graphics.line(self.x + self.width/2, self.y + self.height/2, 
			self.x + self.width/2 + self.dX*10, self.y + self.height/2 + self.dY*10)
		end,

	}
end

return Player