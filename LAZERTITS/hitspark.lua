Object = require "classic"

Hitspark = Object.extend(Object)


local frames = {
  love.graphics.newImage("stills/sonicExplosion00.png"),
  love.graphics.newImage("stills/sonicExplosion00.png"),
  love.graphics.newImage("stills/sonicExplosion01.png"),
  love.graphics.newImage("stills/sonicExplosion01.png"),
  love.graphics.newImage("stills/sonicExplosion02.png"),
  love.graphics.newImage("stills/sonicExplosion02.png"),
  love.graphics.newImage("stills/sonicExplosion03.png"),
  love.graphics.newImage("stills/sonicExplosion03.png"),
  love.graphics.newImage("stills/sonicExplosion04.png"),
  love.graphics.newImage("stills/sonicExplosion04.png"),
  love.graphics.newImage("stills/sonicExplosion05.png"),
  love.graphics.newImage("stills/sonicExplosion05.png"),
  love.graphics.newImage("stills/sonicExplosion06.png"),
  love.graphics.newImage("stills/sonicExplosion06.png"),
  love.graphics.newImage("stills/sonicExplosion07.png"),
  love.graphics.newImage("stills/sonicExplosion07.png"),
  love.graphics.newImage("stills/sonicExplosion08.png"),
  love.graphics.newImage("stills/sonicExplosion08.png")
}


function Hitspark.new(self, x, y)
  self.x = x
  self.y = y
  self.frames_shown = 0
end


function Hitspark.draw(self)
  love.graphics.setColor(1, 1, 1)

  local frame = frames[self.frames_shown + 1]
  -- this will need an offset
  love.graphics.draw(frame,
                     self.x - frame:getWidth()/4,
                     self.y - frame:getHeight()/4,
                     0, 0.5, 0.5)
end

function Hitspark.update(self)
  self.frames_shown = self.frames_shown + 1

  if frames[self.frames_shown + 1] == nil then
    return false
  end
  return true
end

return Hitspark
