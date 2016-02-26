local class = require "lib.middleclass"

local Point = class("util.Point")

local function getX(v) return v.x or v[1] or v.width or v.w end
local function getY(v) return v.y or v[2] or v.height or v.h end
local function getXY(v) return getX(v), getY(v) end

function Point:initialize(x, y)
  if type(x) == "table" then x, y = getXY(x) end
  assert(type(x) == "number" and type(y) == "number")

  self.x, self.y = x, y
end

function Point.__add(a, b)
  local x1, y1 = getXY(a)
  local x2, y2 = getXY(b)
  return Point(x1 + x2, y1 + y2)
end

function Point.__sub(a, b)
  local x1, y1 = getXY(a)
  local x2, y2 = getXY(b)
  return Point(x1 - x2, y1 - y2)
end

function Point.__eq(a, b)
  local x1, y1 = getXY(a)
  local x2, y2 = getXY(b)
  return x1 == x2 and y1 == y2
end

function Point:__call()
  return self.x, self.y
end

function Point.static.resolveFunctionArgs(x, y)
  if class.Object.isInstanceOf(x, Point) then
    return x
  else
    return Point(x, y)
  end
end

return Point
