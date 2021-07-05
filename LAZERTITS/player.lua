Object = require "classic"

-- we'll likely refactor out stuff that's like... "entity"

Player = Object.extend(Object)

function Player.new(self, x, y)
  self.x = x
  self.y = y
  self.height = 150
  self.width = 50

  self.health = 5
  self.will = 5

  self.state = "IDLE"

  self.pchypno_sheet = Animation("animations/pchypno_1.png", 4)
  self.pcidle_sheet = Animation("animations/pcidle_2.png", 4)
  self.pcmove_sheet = Animation("animations/pcmove_2.png", 4)
  self.pcshoot_sheet = Animation("animations/pcshoot.png", 5)
end

function Player.hypno(self)
  self.state = "HYPNO"
end

function Player.move(self)
  self.state = "MOVE"
  self.height = 80
  self.width = 100
end

function Player.idle(self)
  self.state = "IDLE"
  self.height = 150
  self.width = 50
end

function Player.shoot(self)
  self.state = "SHOOT"
  self.height = 150
  self.width = 50
end

function Player.draw(self)
    love.graphics.setColor(1, 1, 1, 1)

    if self.state == "HYPNO" then
      -- hypno offset for center of hips is: 46, 82
      self.pchypno_sheet.draw(self.pchypno_sheet, timer,
                              self.x - 56, self.y - 82)
      HypnoSpiral:draw_cone(self.x + 115 - 46, self.y + 55 - 82)
    elseif self.state == "MOVE" then
      -- move offset for center of hips is: 89, 64
      self.pcmove_sheet.draw(self.pcmove_sheet, timer,
                             self.x - 89, self.y - 64)
    elseif self.state == "SHOOT" then
      -- shoot offset for center of hips is: 68, 95
      self.pcshoot_sheet.draw(self.pcshoot_sheet, timer,
                             self.x - 68, self.y - 90)
    elseif self.state == "IDLE" then
      self.pcidle_sheet.draw(self.pcidle_sheet, timer,
                             self.x - 70, self.y - 92)
    else
      print("this seems wrong")
    end

    love.graphics.rectangle("line",
                            self.x - (self.width/2),
                            self.y - (self.height/2),
                            self.width,
                            self.height)
end
