local class = require "lib.middleclass"

local Size = class("util.Size")

local function getW(v) return v.width or v.w or v[1] or v.x end
local function getH(v) return v.height or v.h or v[2] or v.y end
local function getWH(v) return getW(v), getH(v) end

function Size:initialize(width, height)
  if type(width) == "table" then width, height = getWH(width) end
  assert(type(width) == "number" and type(height) == "number")

  self.width, self.height = width, height
end

function Size.__add(a, b)
  local w1, h1 = getWH(a)
  local w2, h2 = getWH(b)
  return Size(w1 + w2, h1 + h2)
end

function Size.__sub(a, b)
  local w1, h1 = getWH(a)
  local w2, h2 = getWH(b)
  return Size(w1 - w2, h1 - h2)
end

function Size.__eq(a, b)
  local w1, h1 = getWH(a)
  local w2, h2 = getWH(b)
  return w1 == w2 and h1 == h2
end

function Size:__call()
  return self.width, self.height
end

function Size.static.resolveFunctionArgs(width, height)
  if type(width) == "table" and width.class == Size then
    return width
  else
    return Size(width, height)
  end
end

return Size
