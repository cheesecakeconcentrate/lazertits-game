Object = require "classic"
Enemy = require "enemy"

require "animation"

EvilQueen = Enemy.extend(Enemy)

local queenhypno_sheet = Animation("animations/queenhypno.png", 4)
local queenhit_sheet = Animation("animations/queenhit.png", 4)
local queenidle_sheet = Animation("animations/queenidle_1.png", 4)

function EvilQueen.new(self, x, y)
  EvilQueen.super.new(self, x, y)

  self.width = 90
  self.height = 160
  self.state = "IDLE"
end

function EvilQueen.draw(self)
    EvilQueen.super.draw(self)

    if self.state == "HYPNO" then
      -- center of queen's hips is 58,92
      queenhypno_sheet.draw(queenhypno_sheet, timer,
                            self.x - 58, self.y - 92, true)
      HypnoSpiral:draw_cone(self.x - 110 + 58, self.y + 65 - 92, true)
    elseif self.state == "MOVE" then
      -- move offset for center of hips is: 89, 64
      -- self.pcmove_sheet.draw(self.pcmove_sheet, timer,
      --                        self.x - 89, self.y - 64)
    elseif self.state == "SHOOT" then
      -- shoot offset for center of hips is: 68, 95
      -- self.pcshoot_sheet.draw(self.pcshoot_sheet, timer,
      --                        self.x - 68, self.y - 90)
    elseif self.state == "IDLE" then
      queenidle_sheet.draw(queenidle_sheet, timer,
                             self.x - 45, self.y - 92, true)
    elseif self.state == "HIT" then
      queenhit_sheet.draw(queenhit_sheet, timer,
                             self.x - 45, self.y - 92, true)
    else
      print("this seems wrong")
    end

end

return EvilQueen
