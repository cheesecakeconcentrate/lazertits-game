Object = require "classic"

Entity = Object.extend(Object)

function Entity.new(self, x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.state = "IDLE"
end

function Entity.draw(self)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.circle("fill", self.x, self.y, 10, 10)

    love.graphics.rectangle("line",
                            self.x - (self.width/2),
                            self.y - (self.height/2),
                            self.width,
                            self.height)
end

return Entity
