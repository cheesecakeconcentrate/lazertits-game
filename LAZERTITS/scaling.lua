Scaling = {}

local x_scale = 1.0
local y_scale = 1.0

local WIDTH = 1600
local HEIGHT = 1200

function Scaling:get_width()
    return (love.graphics.getWidth() / x_scale)
end

function Scaling:get_height()
    return (love.graphics.getHeight() / y_scale)
end

function Scaling:set_window_size()
  love.window.setMode(WIDTH * x_scale, HEIGHT * y_scale)
end

function Scaling:reset_size()
  x_scale = 1.0
  y_scale = 1.0
  Scaling:set_window_size()
end

function Scaling:increase_size()
    x_scale = x_scale + 0.2
    y_scale = y_scale + 0.2
    love.window.setMode(WIDTH * x_scale, HEIGHT * y_scale)
end

function Scaling:decrease_size()
    x_scale = x_scale - 0.2
    y_scale = y_scale - 0.2
    love.window.setMode(WIDTH * x_scale, HEIGHT * y_scale)
end

function Scaling:scale_graphics()
  love.graphics.scale(x_scale, y_scale)
end
