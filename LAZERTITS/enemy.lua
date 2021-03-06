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
  self.speed = 100

  self.wave_angle = math.random(0, 2*math.pi)
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
  if self.hitstun > 0 then
    self.hitstun = self.hitstun - 1

    if self.hitstun == 0 and self.state == "HIT" then
      self.state = "IDLE"
    else
      return
    end
  end

  -- self.wrapping_chase(self, player, enemies, dt)
  self.wrapping_wave(self, player, enemies, dt)
end

function Enemy.wrapping_wave(self, player, enemies, dt)
  -- simple wave behavior
  -- except we wrap to the other side and always want to move left

  self.wave_angle = self.wave_angle + dt

  local off_screen_x = -(100 + self.width)
  local my_dx = self.speed * sign(off_screen_x - self.x)
  local my_dy = self.speed * math.sin(self.wave_angle)

  self.x = math.floor(self.x + my_dx * dt)
  self.y = math.floor(self.y + my_dy * dt)
  if self.y < 0 then
    self.y = 0
  end
  if self.y > Scaling:get_height() then
    self.y = Scaling:get_height()
  end

  -- wrap!!
  if self.x < -(self.width) then
    self.x = Scaling:get_width() + math.random(0, 20)
    self.y = math.random(0, Scaling:get_height())
  end
end

function Enemy.wrapping_chase(self, player, enemies, dt)
  -- simple chase behavior
  -- except we wrap to the other side and always want to move left

  local off_screen_x = -(100 + self.width) -- player.x + 100
  -- we want to chase the player
  local my_dx = self.speed * sign(off_screen_x - self.x)
  local my_dy = self.speed * sign(player.y - self.y)

  -- don't jitter.
  if math.abs(off_screen_x - self.x) < 5 then
    my_dx = 0
  end
  if math.abs(player.y - self.y) < 5 then
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

  -- wrap!!
  if self.x < -(self.width) then
    self.x = Scaling:get_width() + math.random(0, 20)
    self.y = math.random(0, Scaling:get_height())
  end
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
