Object = require "classic"
SpaceVampire = require "spacevampire"

BigGun = SpaceVampire.extend(SpaceVampire)

local biggun_sprite = love.graphics.newImage("stills/enemy3.png")

function BigGun.new(self, x, y)
  BigGun.super.new(self, x, y)
  self.sprite = biggun_sprite

  self.width = self.sprite:getWidth()
  self.height = self.sprite:getHeight()
  self.speed = 50
  self.state = "IDLE"
end

return BigGun
