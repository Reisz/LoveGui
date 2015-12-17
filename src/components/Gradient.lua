local class = require "util.middleclass"
local Component = require "util.Component"

local straightShader = love.graphics.newShader [[
  extern Image buffer;
  extern vec2 direction;

  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 result = Texel(buffer, vec2(dot(texture_coords, direction), 0));
    result.a *= Texel(texture, texture_coords).a * color.a;
    return result;
  }
]]

local radialShader = love.graphics.newShader [[
  extern Image buffer;
  //extern vec2 center;

  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 center = vec2(0.5, 0.5);
    vec4 result = Texel(buffer, vec2(length(texture_coords - center), 0));
    result.a *= Texel(texture, texture_coords).a * color.a;
    return result;
  }
]]


local Gradient = class("Gradient", Component)

Gradient.property.type = "vertical"
Gradient.property.type:setMatcher("v{'horizontal', 'vertical', 'radial'}")

Gradient.property.stops = Component.default({})
Gradient.property.stops:setMatcher([[
  list(tbl{
    pos = t.number,
    color = list(t.number, 3, 4)
  })
]])

function Gradient:initialize()
  local function deleteCache() self.cached = nil end
  self.properties.type:bind(deleteCache)
  self.properties.stops:bind(deleteCache)()
end

local function compStops(x, y) return x.pos < y.pos end
local function get_rgba(tbl) return tbl[1], tbl[2], tbl[3], tbl[4] or 255 end
local function mix(col1, col2, fac)
  local r1, g1, b1, a1 = get_rgba(col1)
  local r2, g2, b2, a2 = get_rgba(col2)
  local r3, g3, b3, a3 = r2 - r1, g2 - g1, b2 - b1, a2 - a1
  return r1 + r3 * fac, g1 + g3 * fac, b1 + b3 * fac, a1 + a3 * fac
end
function Gradient:generate(length)
  table.sort(self.stops, compStops)
  local canvas = love.image.newImageData(length, 1)
  local first, last = self.stops[1], self.stops[#self.stops]
  local index, current, next = 2, self.stops[1], self.stops[2]
  for i = 0, length - 1 do
    local quot = i / (length - 1)
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


function Gradient:prepare(width, height)
  if self.canvasWidth ~= width or self.canvasHeight ~= height then
    self.canvasWidth = width; self.canvasHeight = height
    self.canvas = love.graphics.newCanvas(width, height)
  else
    self.canvas:clear()
  end
  self.otherCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.canvas)
  love.graphics.push()
  love.graphics.origin() -- TODO 1.8 compatible solution
end

local direction = {
  vertical = {0, 1},
  horizontal = {1, 0}
}
function Gradient:apply(width, height)
  local shader, length
  if self.type == "radial" then
    local x, y = width / 2, height / 2

    length = math.sqrt(x * x + y * y)
    shader = radialShader
  else
    local dir = direction[self.type]
    straightShader:send("direction", dir)

    length = width * dir[1] + height * dir[2]
    shader = straightShader
  end

  if self.cache ~= length then self.buffer = self:generate(length) end
  shader:send("buffer", self.buffer)

  local otherShader = love.graphics.getShader()
  love.graphics.setCanvas(self.otherCanvas)
  love.graphics.setShader(shader)
  love.graphics.pop()
  love.graphics.draw(self.canvas, 0, 0)
  love.graphics.setShader(otherShader)
end

return Gradient
