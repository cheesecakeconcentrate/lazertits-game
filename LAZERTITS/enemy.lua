Object = require "classic"
Entity = require "entity"

Enemy = Entity.extend(Entity)

function Enemy.draw(self)
    Enemy.super.draw(self)
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function Enemy.move(self, player, dt)
  -- simple chase behavior

  local my_dx = 100 * sign(player.x - self.x)
  local my_dy = 100 * sign(player.y - self.y)

  self.x = self.x + my_dx * dt
  self.y = self.y + my_dy * dt
end

return Enemy
