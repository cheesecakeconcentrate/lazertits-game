Object = require "classic"

require "stars"

Stage = Object.extend(Object)

function Stage.new(self)
  self.state = "STARS"

  self.star_sprite = love.graphics.newImage("stills/star1.png")
  self.entangled = love.graphics.newImage("stills/entangled.png")

  -- OK then just update this by moving stars to the left etc.
  -- fill this in with random locations and (discrete) sizes
  self.stars_pairs = Stars:random_table(20)
  self.radians = 0
end

function Stage.draw(self)
  if self.state == "STARS" then
    self.drawStars(self)
  elseif self.state == "CHAMBER" then
    self.drawChamber(self)
  end
end

function Stage.drawStars(self)
  love.graphics.setColor(1.0, 1.0, 1.0)
  for i,star_pair in ipairs(self.stars_pairs) do
    love.graphics.draw(self.star_sprite, star_pair[1], star_pair[2], 0,
                       star_pair[3])
  end
end

function Stage.drawChamber(self)
    -- good for the fight versus the evil queen
    love.graphics.setColor(math.random(), math.random(), math.random(), 0.2)
    love.graphics.draw(self.entangled, 
                       400, 300,
                       self.radians,
                       1000.0 / self.entangled:getWidth(),
                       1000.0 / self.entangled:getHeight(),
                       self.entangled:getWidth()/2,
                       self.entangled:getHeight()/2)
end


function Stage.update(self, dt)
  self.stars_pairs = Stars:update_table(self.stars_pairs, dt)
  self.radians = self.radians + (dt / 7)
end

return Stage
