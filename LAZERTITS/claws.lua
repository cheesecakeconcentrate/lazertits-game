Object = require "classic"
SpaceVampire = require "spacevampire"

Claws = SpaceVampire.extend(SpaceVampire)

local claws_sprite = love.graphics.newImage("stills/enemy1.png")

function Claws.new(self, x, y)
  Claws.super.new(self, x, y)
  self.sprite = claws_sprite

  self.width = self.sprite:getWidth()
  self.height = self.sprite:getHeight()
  self.speed = 300
  self.state = "IDLE"
end

return Claws
