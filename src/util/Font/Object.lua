local class = require "util.middleclass"

local FontObject = class("FontObject")

--- @param font [Font, FontData]
function FontObject:initialize(font, size)
  if font:typeOf("FontData") then
    self.font = love.graphics.newFont(font, size)
  else
    self.font = font
  end
  self.size = size
end

function FontObject:getAscent() return self.font:getAscent() end
function FontObject:getBaseline() return self.font:getBaseline() end
function FontObject:getDescent() return self.font:getDescent() end

function FontObject:getFilter()
  return self.font:getFilter()
end
function FontObject:setFilter(minFilter, magFilter, anisotropy)
  self.font:setFilter(minFilter, magFilter, anisotropy)
end

local function _print(self, text, method, filter, ...)
  love.graphics.setFont(self.font)
  local mif, maf, ani = self.font:getFilter()
  self.font:setFilter(filter.minFilter or mif, filter.magFilter or maf, filter.anisotropy or ani)
  love.graphics[method](text, ...)
  self.font:setFilter(mif, maf, ani)
end

function FontObject:print(text, filter, x, y, r, sx, sy, kx, ky)
  _print(self, text, "print", filter, x, y, r, sx, sy, kx, ky)
end

function FontObject:printf(text, filter, x, v, limit, align, r, sx, sy, kx, ky)
  _print(self, text, "printf", filter, x, v, limit, align, r, sx, sy, kx, ky)
end

function FontObject:getWidth(text)
  return self.font:getWidth(text)
end

function FontObject:getHeight()
  return self.font:getHeight()
end

function FontObject:getSize()
  return self.size
end

local glyphsets = {
  a = "abcdefghijklmnopqrstuvwxyz",
  A = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  d = "0123456789",
  s = " "
}
FontObject.static.glyphs = setmetatable({}, {
  __index = function(_, key)
    local result = {}
    for c in string.gmatch(key, ".") do
      table.insert(result, glyphsets[c])
    end
    return table.concat(result)
  end, __newindex = function() end
})

return FontObject
