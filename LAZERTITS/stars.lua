Stars = {}

function Stars:random_table(nstars)
  local out = {}

  for i=1,nstars do
    out[i] = {math.random(0,800), math.random(600), (1 / 2^(math.random(1,3)))}
  end
  return out
end

function Stars:update_table(table, dt)
  local out = {}

  for i,star_pair in ipairs(table) do
    local x = star_pair[1]
    local y = star_pair[2]
    local size = star_pair[3]
    x = x - (200 * dt * size)
    if x < 0 then
      x = 800
    end
    out[i] = {x, y, size}
  end
  return out
end
