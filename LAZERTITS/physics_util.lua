function collides(a, b)
  -- based on https://sheepolution.com/learn/book/13 , thanks!
  local a_left = a.x - (a.width/2)
  local a_right = a.x + (a.width/2)
  local a_top = a.y - (a.height/2)
  local a_bottom = a.y + (a.height/2)

  local b_left = b.x - (b.width/2)
  local b_right = b.x + (b.width/2)
  local b_top = b.y - (b.height/2)
  local b_bottom = b.y + (b.height/2)

  if a_right > b_left and
  a_left < b_right and
  a_bottom > b_top and
  a_top < b_bottom then
    return true
  end

  return false
end
