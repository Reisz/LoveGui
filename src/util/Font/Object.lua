local class = require "util.middleclass"

local FontObject = class("FontObject")

--- @param font [Font, ImageFont, FontData]
function FontObject:initialize(font, size)
  if font:typeOf("FontData") then
    self.font = love.graphics.newFont(font, size)
  else
    self.font = font
    -- TODO scale?
  end
end

function FontObject:print(text, x, y, r, sx, sy, kx, ky)
  love.graphics.setFont(self.font)
  love.graphics.print(text, x, y, r, sx, sy, kx, ky)
end

function FontObject:printf(text, x, v, limit, align, r, sx, sy, kx, ky)
  love.graphics.setFont(self.font)
  love.graphics.print(text, x, v, limit, align, r, sx, sy, kx, ky)
end

function FontObject:getFilter()
  return self.font:getFilter()
end

function FontObject:setFilter(minFilter, magFilter, anisotropy)
  self.font:setFilter(minFilter, magFilter, anisotropy)
end

return FontObject
