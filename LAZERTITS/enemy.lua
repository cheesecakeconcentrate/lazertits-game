Object = require "classic"
Entity = require "entity"

Enemy = Entity.extend(Entity)

function Enemy.draw(self)
    Enemy.super.draw(self)
end

return Enemy
