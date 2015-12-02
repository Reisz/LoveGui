local pi, halfPi = math.pi, math.pi / 2

local function fill(width, height, radius, segments)
  if radius > 0 then
    local innerWidth, innerHeight = width - 2 * radius, height - 2 * radius
    local rightInnerEdge, botInnerEdge = radius + innerWidth, radius + innerHeight
    -- center, top, bottom, left, right
    love.graphics.rectangle("fill", radius, radius, innerWidth, innerHeight)
    love.graphics.rectangle("fill", radius, 0, innerWidth, radius)
    love.graphics.rectangle("fill", radius, botInnerEdge, innerWidth, radius)
    love.graphics.rectangle("fill", 0, radius, radius, innerHeight)
    love.graphics.rectangle("fill", rightInnerEdge, radius, radius, innerHeight)

    -- topleft, topright, bottomleft, bottomright
    love.graphics.arc("fill", radius, radius, radius, pi, pi + halfPi, segments)
    love.graphics.arc("fill", rightInnerEdge, radius, radius, -halfPi, 0, segments)
    love.graphics.arc("fill", radius, botInnerEdge, radius, halfPi, pi, segments)
    love.graphics.arc("fill", rightInnerEdge, botInnerEdge, radius, 0, halfPi, segments)
  else
    love.graphics.rectangle("fill", 0, 0, width, height)
  end
end

return fill
