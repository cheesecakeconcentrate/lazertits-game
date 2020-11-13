Object = require "classic"
Enemy = require "enemy"

SpaceVampire = Enemy.extend(Enemy)

function SpaceVampire.new(self, x, y)
  SpaceVampire.super.new(self, x, y)
  self.state = "IDLE"
end

function SpaceVampire.draw(self)
    SpaceVampire.super.draw(self)
    love.graphics.setColor(1, 1, 1)

    if self.state == "IDLE" then
      love.graphics.draw(self.sprite, self.x + self.width / 2,
                                      self.y - self.height / 2,
                                      0, -1, 1)
    elseif self.state == "HIT" then
      love.graphics.setColor(1, 1, 1, 0.5)
      local jitter_x = math.random(-5, 5)
      local jitter_y = math.random(-5, 5)
      love.graphics.draw(self.sprite, self.x + self.width / 2 + jitter_x,
                                      self.y - self.height / 2 + jitter_y,
                                      0, -1, 1)
    elseif self.state == "DYING" then
      love.graphics.setColor(1, 1, 1, 0.5)
      local jitter_x = math.random(-5, 5)
      local jitter_y = math.random(-5, 5)
      love.graphics.draw(self.sprite, self.x + self.width / 2 + jitter_x,
                                      self.y - self.height / 2 + jitter_y,
                                      0, -1, 1)
    else
      print("this seems wrong")
    end

end

return SpaceVampire
