Object = require "classic"
Entity = require "entity"

SpiralHitbox = Entity.extend(Entity)

function SpiralHitbox.new(self, x, y)
  self.x = x
  self.y = y
  self.width = 115
  self.height = 140
  self.state = "IDLE"
end

function SpiralHitbox.draw(self)
    SpiralHitbox.super.draw(self)
end

return SpiralHitbox
