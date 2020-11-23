Object = require "classic"

require "stars"
require "scaling"

Stage = Object.extend(Object)

function Stage.new(self)
  self.state = "STARS"

  self.star_sprite = love.graphics.newImage("stills/star1.png")
  self.entangled = love.graphics.newImage("stills/entangled.png")

  self.forest_layers = {
    love.graphics.newImage("stills/forest-b-layer1.png"),
    love.graphics.newImage("stills/forest-b-layer2.png"),
    love.graphics.newImage("stills/forest-b-layer3.png"),
    love.graphics.newImage("stills/forest-b-layer4.png")
  }
  self.scrolls = {0, 0, 0}

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
  elseif self.state == "FOREST" then
    self.drawForest(self)
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

  local center_x = Scaling:get_width() / 2
  local center_y = Scaling:get_height() / 2
  love.graphics.draw(self.entangled,
                     center_x, center_y,
                     self.radians,
                     2000.0 / self.entangled:getWidth(),
                     2000.0 / self.entangled:getHeight(),
                     self.entangled:getWidth()/2,
                     self.entangled:getHeight()/2)
end

function Stage.drawForest(self)
  love.graphics.setColor(1.0, 1.0, 1.0)

  love.graphics.draw(self.forest_layers[1], 0, 0, 0, 2.0, 2.0)

  for i=1,3 do
    -- we're stretching out the pixel forest to be double-tall but only
    -- single-wide right now. It looks OK, kind of alien and spindley, which is
    -- maybe alright?
    love.graphics.draw(self.forest_layers[i+1], self.scrolls[i], 0, 0, 1.0, 2.0)
    love.graphics.draw(self.forest_layers[i+1],
                       self.scrolls[i] + self.forest_layers[i+1]:getWidth(),
                       0, 0, 1.0, 2.0)
  end
end


function Stage.update(self, dt)
  self.stars_pairs = Stars:update_table(self.stars_pairs, dt)
  self.radians = self.radians + (dt / 7)

  for i=1,3 do
    self.scrolls[i] = self.scrolls[i] - (100 * i * dt)
    if self.scrolls[i] < (-self.forest_layers[i+1]:getWidth()) then
      self.scrolls[i] = 0
    end
  end

end

return Stage
