Object = require "classic"

Animation = Object.extend(Object)

function Animation.new(self, filename, frames)
  self.quads = {}
  -- quads = {}
  self.spritesheet = love.graphics.newImage(filename)
  self.frames = frames

  local imgWidth = self.spritesheet:getWidth()
  local imgHeight = self.spritesheet:getHeight()
  local spriteWidth = imgWidth / self.frames
  for i=0,self.frames-1 do
    table.insert(self.quads,
                 love.graphics.newQuad(i * spriteWidth, 0,
                                       spriteWidth, imgHeight,
                                       self.spritesheet:getDimensions()))
  end
end

function Animation.draw(self, timer, x, y, mirrored)
  mirrored = mirrored or false
 
  scale_x = 1
  scale_y = 1
  rotation = 0
  if mirrored then
    scale_x = -1
    local imgWidth = self.spritesheet:getWidth()
    local spriteWidth = imgWidth / self.frames
    x = x + spriteWidth
  end

  love.graphics.draw(self.spritesheet,
                     self.quads[(math.floor(timer) % self.frames) + 1],
                     x, y, rotation, scale_x, scale_y)


end
