Object = require "classic"
Enemy = require "enemy"

require "animation"

Claws = Enemy.extend(Enemy)

local claws_sprite = love.graphics.newImage("stills/enemy1.png")

function Claws.new(self, x, y)
  Claws.super.new(self, x, y)

  self.width = claws_sprite:getWidth()
  self.height = claws_sprite:getHeight()
  self.state = "IDLE"
end

function Claws.draw(self)
    Claws.super.draw(self)
    love.graphics.setColor(1, 1, 1)

    if self.state == "IDLE" then
      love.graphics.draw(claws_sprite, self.x + self.width / 2,
                                       self.y - self.height / 2,
                                       0, -1, 1)
    elseif self.state == "HIT" then
      love.graphics.setColor(1, 1, 1, 0.5)
      local jitter_x = math.random(-10, 10)
      local jitter_y = math.random(-10, 10)
      love.graphics.draw(claws_sprite, self.x + self.width / 2 + jitter_x,
                                       self.y - self.height / 2 + jitter_y,
                                       0, -1, 1)
    elseif self.state == "DYING" then
      love.graphics.setColor(1, 1, 1, 0.5)
      local jitter_x = math.random(-10, 10)
      local jitter_y = math.random(-10, 10)
      love.graphics.draw(claws_sprite, self.x + self.width / 2 + jitter_x,
                                       self.y - self.height / 2 + jitter_y,
                                       0, -1, 1)
    else
      print("this seems wrong")
    end

end

return Claws
