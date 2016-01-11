local class = require "util.middleclass"

local FontObject = class("FontObject")

--- @param font [Font, Data]
function FontObject:initialize(font, size)
  if font:typeOf("Font") then
    self.font = font
  else
    self.font = love.graphics.newFont(font, size)
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

function FontObject:print(text, ...)
  _print(self, text, "print", ...)
end

--[[function FontObject:printf(text, filter, x, y, limit, align, r, sx, sy, kx, ky)
  _print(self, text, "printf", filter, x, y, limit, align, r, sx, sy, kx, ky)
end]]

function FontObject:layout(text)
  local linecount = select(2, string.gsub(text, "\n", ""))
  linecount = linecount > 0 and linecount or 1
  return {
    text = text, method = "print",
    width = self:getWidth(text),
    height =  linecount * self:getHeight()
  }
end

function FontObject:getLayoutSize(layout)
  return layout.width, layout.height
end

function FontObject:present(layout, filter, ...)
  if layout.method == "print" then
    _print(self, layout.text, layout.method, filter, ...)
  else
    _print(self, layout.text, layout.method, filter, layout.limit, layout.align, ...)
  end
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

FontObject.static.glyphs = require "util.Font.glyphs"

return FontObject
