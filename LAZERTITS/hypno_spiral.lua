HypnoSpiral = {}

local start_angle = 0

function HypnoSpiral:draw_cone(startx, starty, queen)
  love.graphics.setLineStyle("rough")
  love.graphics.setLineWidth(5)

  queen = queen or false

  local prevx = 0
  local prevy = 0
  for angle=start_angle,(start_angle+20*math.pi),0.1 do
    local radius = 10 + (angle - start_angle)
    local y = (math.sin(angle) * radius) + starty


    local dir = 1
    if queen then
      dir = - 1
    end
    local x = (math.cos(angle) * (radius / 2) + startx +
               dir * (angle - start_angle))

    if (prevx > 0) and (prevy > 0) then
      if queen then
        if math.random() > 0.5 then
          love.graphics.setColor(0, 1, 0, 0.5)
        else
          love.graphics.setColor(1, 0, 1, 0.5)
        end
      else
        love.graphics.setColor(math.random(), math.random(), math.random(), 0.5)
      end

      love.graphics.line(prevx, prevy, x, y)
    end
    prevx = x
    prevy = y
  end
end

function HypnoSpiral:draw_circular(startx, starty)
  local radius = 1
  local prevx = 0
  local prevy = 0

  love.graphics.setLineStyle("rough")
  love.graphics.setLineWidth(8)

  local my_start_angle = start_angle / 10
  math.randomseed(0)
  -- for angle=my_start_angle,(my_start_angle+1500*math.pi),0.1 do
  for angle=my_start_angle,(my_start_angle+35*math.pi),0.1 do
    local radius = 1 + (angle - my_start_angle)
    local x = (math.cos(angle) * radius) + startx
    local y = (math.sin(angle) * radius) + starty
    if (prevx > 0) and (prevy > 0) then
      love.graphics.setColor(math.random(), math.random(), math.random(),
                             0.3 * math.abs(math.sin(start_angle)))
      love.graphics.line(prevx, prevy, x, y)
    end
    prevx = x
    prevy = y
  end
end

function HypnoSpiral:update(dt)
  start_angle = start_angle + (dt * 0.75)
end
