Object = require "classic"
SpaceVampire = require "spacevampire"

SmallGun = SpaceVampire.extend(SpaceVampire)

local smallgun_sprite = love.graphics.newImage("stills/enemy2.png")

function SmallGun.new(self, x, y)
  SmallGun.super.new(self, x, y)
  self.sprite = smallgun_sprite

  self.width = self.sprite:getWidth()
  self.height = self.sprite:getHeight()
  self.state = "IDLE"
end

return SmallGun
