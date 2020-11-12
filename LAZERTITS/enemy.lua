Object = require "classic"
Entity = require "entity"

Enemy = Entity.extend(Entity)

function Enemy.draw(self)
    Enemy.super.draw(self)

    -- love.graphics.setColor(0.8, 0.8, 0.8)
    -- love.graphics.print("HP: ".. self.health .. " WP: " .. self.will,
    --                     self.x, self.y - 100)
    -- love.graphics.setColor(1.0, 1.0, 1.0)
end


function Enemy.new(self, x, y)
  Enemy.super.new(self, x, y)
  self.hitstun = 0
  self.health = 3
  self.will = 1
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function dist(x1, y1, x2, y2)
  local xdist_square = math.abs(x1 - x2) ^ 2
  local ydist_square = math.abs(y1 - y2) ^ 2
  return math.sqrt(xdist_square + ydist_square)
end


function Enemy.move(self, player, enemies, dt)
  -- simple chase behavior
  -- except we want to get a little to the right of the player

  if self.hitstun > 0 then
    self.hitstun = self.hitstun - 1

    if self.hitstun == 0 and self.state == "HIT" then
      self.state = "IDLE"
    else
      return
    end
  end

  -- we want to chase the player
  local my_dx = 100 * sign((player.x + 100) - self.x)
  local my_dy = 100 * sign(player.y - self.y)

  -- don't jitter.
  if math.abs(my_dx) < 2 then
    my_dx = 0
  end
  if math.abs(my_dy) < 2 then
    my_dy = 0
  end

  -- if we were going to get within (XXX: arbitrary) 100 pixels of another
  -- enemy, don't move into their space in that direction.
  for k,enemy in pairs(enemies) do
    if enemy ~= self then
      local new_x = math.floor(self.x + my_dx * dt)
      local new_y = math.floor(self.y + my_dy * dt)
      if dist(new_x, new_y, enemy.x, enemy.y) < 100 then
        if math.abs(self.x - enemy.x) > math.abs(new_x - enemy.x)  then
          my_dx = 0
        end
        if math.abs(self.y - enemy.y) > math.abs(new_y - enemy.y)  then
          my_dy = 0
        end
      end
    end
  end

  self.x = math.floor(self.x + my_dx * dt)
  self.y = math.floor(self.y + my_dy * dt)
end

function Enemy.gethit(self)
  self.hitstun = 30
  self.health = self.health - 1

  if self.health <= 0 then
    self.state = "DYING"
  else
    self.state = "HIT"
  end
end

function Enemy.getspiraled(self)
  self.hitstun = 30
  self.will = self.will - 1

  if self.will <= 0 then
    self.state = "DYING"
  else
    self.state = "HIT"
  end
end

return Enemy
