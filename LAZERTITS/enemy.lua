Object = require "classic"
Entity = require "entity"

Enemy = Entity.extend(Entity)

function Enemy.draw(self)
    Enemy.super.draw(self)
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function Enemy.new(self, x, y)
  Enemy.super.new(self, x, y)
  self.hitstun = 0
end

function Enemy.move(self, player, dt)
  -- simple chase behavior
  -- except we want to get a little to the right of the player

  if self.hitstun > 0 then
    self.hitstun = self.hitstun - 1

    if self.hitstun == 0 then
      self.state = "IDLE"
    else
      return
    end
  end

  local my_dx = 100 * sign((player.x + 100) - self.x)
  local my_dy = 100 * sign(player.y - self.y)

  self.x = self.x + my_dx * dt
  self.y = self.y + my_dy * dt
end

function Enemy.gethit(self)
  self.hitstun = 30
  self.state = "HIT"
end

return Enemy
