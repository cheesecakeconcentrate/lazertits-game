Object = require "classic"
Enemy = require "enemy"

require "animation"

EvilQueen = Enemy.extend(Enemy)

local queenhypno_sheet = Animation("animations/queenhypno.png", 4)

function EvilQueen.draw(self)
    EvilQueen.super.draw(self)

    -- center of queen's hips is 58,92
    queenhypno_sheet.draw(queenhypno_sheet, timer,
                          self.x - 58, self.y - 92, true)

    HypnoSpiral:draw_cone(self.x - 110 + 58, self.y + 65 - 92, true)
end

return EvilQueen
