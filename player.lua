
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
		oldX = 0,
		oldY = 0,
		
		Walk = function(self, dt)
			
			self.oldX = self.x
			self.oldY = self.y
			
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
			
			love.graphics.setLineWidth(1)
			love.graphics.line(self.x + self.width/2, self.y + self.height/2, 
			self.x + self.width/2 + self.dX*10, self.y + self.height/2 + self.dY*10)
		end,

	}
end

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2) 
	return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1 
end

return Player
