local class = require "util.middleclass"
local Component = require "util.Component"

local Gradient = class("Gradient", Component)

Gradient.property.type = "vertical"
Gradient.property.type:setMatcher("v{'horizontal', 'vertical'}")

Gradient.property.stops = Component.default({})
Gradient.property.stops:setMatcher([[
  list(tbl{
    pos = t.number,
    color = list(t.number, 3, 4)
  })
]])

local function compStops(x, y) return x.pos < y.pos end
local function get_rgba(tbl) return tbl[1], tbl[2], tbl[3], tbl[4] or 255 end
local function mix(col1, col2, fac)
  local r1, g1, b1, a1 = get_rgba(col1)
  local r2, g2, b2, a2 = get_rgba(col2)
  local r3, g3, b3, a3 = r2 - r1, g2 - g1, b2 - b1, a2 - a1
  return r1 + r3 * fac, g1 + g3 * fac, b1 + b3 * fac
end
function Gradient:generate(width)
  table.sort(self.stops, compStops)
  local canvas = love.image.newImageData(width, 1)
  local first, last = self.stops[1], self.stops[#self.stops]
  local index, current, next = 2, self.stops[1], self.stops[2]
  for i = 0, width - 1 do
    local quot = i / (width - 1)
    local r, g, b, a
    if quot < first.pos then
      r, g, b, a = get_rgba(first.color)
    elseif quot >= last.pos then
      r, g, b, a = get_rgba(last.color)
    else
      if quot >= next.pos then
        current = next; index = index + 1; next = self.stops[index]
      end
      local fac = (quot - current.pos) / (next.pos - current.pos)
      r, g, b, a = mix(current.color, next.color, fac)
    end
    canvas:setPixel(i, 0, r, g, b, a)
  end
  return love.graphics.newImage(canvas)
end

return Gradient
