local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Item = require "components.Item"

local ImageFontText = class("ImageFontText", Item.class)

local function updateFont(self, font)
  if love._version_major >= 10 then
    -- for versions 0.10.0 and above
    self._font = love.graphics.newImageFont(font.src, font.glyphs, font.extraSpacing)
  else
    -- for versions 0.8.0 to 0.9.2
    self._font = love.graphics.newImageFont(font.src, font.glyphs)
  end
end

function ImageFontText:initialize(tbl)
  property(self, tbl, "text", "")
  property(self, tbl, "color", {0,0,0}, "tbl{t.number, t.number, t.number, may(t.number)}")

  property.group(self, tbl, "font", {
    src = "", glyphs = "", extraSpacing = 0
  }, { -- flags
    src = "any{t.string, l2t.Image}"
    -- support for all inputs of newImageFont
  })
  component.functionBinding(function(font)
    updateFont(self, font)
  end, self.properties.font)()

  property(self, tbl, "orientation", 0)
  property(self, tbl, "scale", 1, "any{t.number, tbl{t.number, t.number}}")
  property(self, tbl, "offsetX", 0)
  property(self, tbl, "offsetY", 0)
  property(self, tbl, "shearX", 0)
  property(self, tbl, "shearY", 0)

  Item.class.initialize(self, tbl)
end

function ImageFontText:draw()
  local scaleX, scaleY = self.scale, self.scale
  if type(scaleX) == "table" then
    scaleX = scaleX[1]
    scaleY = scaleY[2]
  end

  love.graphics.setColor(self.color)
  love.graphics.setFont(self._font)
  love.graphics.print(self.text, 0, 0, self.orientation, scaleX, scaleY,
    self.offsetX, self.offsetY, self.shearX, self.shearY)
end

local a, A, d = "abcdefghijklmnopqrstuvwxyz",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "0123456789"
ImageFontText.static.alphabet = a
ImageFontText.static.a = a
ImageFontText.static.ALPHABET = A
ImageFontText.static.A = A
ImageFontText.static.digits = d
ImageFontText.static.d = d
ImageFontText.static.aAd = a .. A .. d

return component(ImageFontText)
