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

function FontObject:_print(text, method, filter, ...)
  love.graphics.setFont(self.font)
  local mif, maf, ani = self.font:getFilter()
  self.font:setFilter(filter.minFilter or mif, filter.magFilter or maf, filter.anisotropy or ani)
  love.graphics[method](text, ...)
  self.font:setFilter(mif, maf, ani)
end

function FontObject:print(text, filter, x, y, r, sx, sy, kx, ky)
  self:_print(text, "print", filter, x, y, r, sx, sy, kx, ky)
end

function FontObject:printf(text, filter, x, v, limit, align, r, sx, sy, kx, ky)
  self:_print(text, "printf", filter, x, v, limit, align, r, sx, sy, kx, ky)
end

function FontObject:getFilter()
  return self.font:getFilter()
end

function FontObject:setFilter(minFilter, magFilter, anisotropy)
  self.font:setFilter(minFilter, magFilter, anisotropy)
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

local a, A, d = "abcdefghijklmnopqrstuvwxyz",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "0123456789"
FontObject.static.alphabet = a
FontObject.static.a = a
FontObject.static.ALPHABET = A
FontObject.static.A = A
FontObject.static.digits = d
FontObject.static.d = d
FontObject.static.space = " "
FontObject.static.s = " "
FontObject.static.saAd = " " .. a .. A .. d
-- TODO dynamic combinations via __index

return FontObject
