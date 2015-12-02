local pi, halfPi, tau = math.pi, math.pi / 2, math.pi * 2

local function arc(x, y, radius, angle1, angle2, segments)
  segments = segments or 10

  local step, angle, points = (tau / segments), angle1, {}
  if angle1 > angle2 then step = -step end

  while (angle < angle2) do
    table.insert(points, x + (math.cos(angle) * radius))
    table.insert(points, y - (math.sin(angle) * radius))
    angle = angle + step
  end
  table.insert(points, x + (math.cos(angle2) * radius))
  table.insert(points, y - (math.sin(angle2) * radius))

  if #points >= 4 then
    return unpack(points)
  end
end

local function appendAll(tbl, ...)
  local newIndex = #tbl
  for i = 1, select("#", ...) do
    tbl[newIndex + i] = select(i, ...)
  end
end

local function fill(width, height, radius, segments)
  if radius > 0 then
    local innerWidth, innerHeight = width - 2 * radius, height - 2 * radius
    local rightInnerEdge, botInnerEdge = radius + innerWidth, radius + innerHeight
    
    -- topright, topleft, bottomleft, bottomright
    local points = {}
    appendAll(points, arc(rightInnerEdge, radius, radius, 0, halfPi, segments))
    appendAll(points, arc(radius, radius, radius, halfPi, pi, segments))
    appendAll(points, arc(radius, botInnerEdge, radius, pi, pi + halfPi, segments))
    appendAll(points, arc(rightInnerEdge, botInnerEdge, radius, pi + halfPi, tau, segments))
    appendAll(points, width, radius)

    love.graphics.line(points)
  else
    love.graphics.rectangle("line", 0, 0, width, height)
  end
end

return fill
