Object = require "classic"

-- we'll likely refactor out stuff that's like... "entity"

Player = Object.extend(Object)

function Player.new(self, x, y)
  self.x = x
  self.y = y
  self.state = "IDLE"

  self.pchypno_sheet = Animation("animations/pchypno_1.png", 4)
  self.pcidle_sheet = Animation("animations/pcidle_2.png", 4)
  self.pcmove_sheet = Animation("animations/pcmove_2.png", 4)
end

function Player.hypno(self)
  self.state = "HYPNO"
end

function Player.move(self)
  self.state = "MOVE"
end

function Player.idle(self)
  self.state = "IDLE"
end

function Player.draw(self)
    love.graphics.setColor(1, 1, 1, 1)

    if player.state == "HYPNO" then
      -- hypno offset for center of hips is: 46, 82
      self.pchypno_sheet.draw(self.pchypno_sheet, timer,
                              self.x - 56, self.y - 82)
      HypnoSpiral:draw_cone(self.x + 115 - 46, self.y + 55 - 82)
    elseif player.state == "MOVE" then
      -- move offset for center of hips is: 89, 64
      self.pcmove_sheet.draw(self.pcmove_sheet, timer,
                             self.x - 89, self.y - 64)
    else
      self.pcidle_sheet.draw(self.pcidle_sheet, timer,
                             self.x - 70, self.y - 92)
    end
end
