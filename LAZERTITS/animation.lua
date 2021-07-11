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

function Animation.draw_big(self, timer, x, y, frame_indices)
  -- frame_indices is a list of indexes into the spritesheet. this is silly.
  frame_to_show = frame_indices[(math.floor(timer) %
                                 table.getn(frame_indices)) + 1]
  -- print(frame_to_show)

  scale_x = 4
  scale_y = 4
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.spritesheet, self.quads[frame_to_show],
                     x, y, rotation, scale_x, scale_y)
end
