Object = require "classic"
Entity = require "entity"

Laser = Entity.extend(Entity)

local sprite = love.graphics.newImage("stills/laser.png")

function Laser.new(self, x, y)
  self.x = x
  self.y = y
  self.width = sprite:getWidth() / 2
  self.height = sprite:getHeight() / 2
  self.state = "IDLE"
end

function Laser.draw(self)
    Laser.super.draw(self)
    love.graphics.draw(sprite, self.x - self.width / 2,
                               self.y - self.height / 2,
                               0, 0.5, 0.5)
end

return Laser


