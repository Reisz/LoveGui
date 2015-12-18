--- DEPRECATED will use central font registry accessed by Component Text
local class = require "util.middleclass"
local matcher = require "util.matching"

local Item = require "components.Item"

local ImageFontText = class("ImageFontText", Item)

ImageFontText.property.text = ""
ImageFontText.property.color = {0,0,0}
ImageFontText.property.color:setMatcher("tbl{t.number, t.number, t.number, may(t.number)}")

ImageFontText.property.font = Item.group {
  src = "", glyphs = "", extraSpacing = 0,
  minFilter = "linear", magFilter = "linear", anisotropy = 1
}
ImageFontText.property.font.src:setMatcher("any{t.string, l2t.Image}") -- support for all inputs of newImageFont
local filterMatcher = matcher("v{'linear', 'nearest'}")
ImageFontText.property.font.minFilter:setMatcher(filterMatcher)
ImageFontText.property.font.magFilter:setMatcher(filterMatcher)

ImageFontText.property.orientation = 0
ImageFontText.property.scale = 1
ImageFontText.property.scale:setMatcher("any{t.number, tbl{t.number, t.number}}")
ImageFontText.property.offsetX = 0
ImageFontText.property.offsetY = 0
ImageFontText.property.shearX = 0
ImageFontText.property.shearY = 0


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
  self.properties.font:bind(function(font) updateFont(self, font) end)()
  local function updateFilter()
    if self._font then
      self._font:setFilter(self.font.minFilter, self.font.magFilter, self.font.anisotropy)
    end
  end
  self.properties.font.minFilter:bind(updateFilter)
  self.properties.font.magFilter:bind(updateFilter)
  self.properties.font.anisotropy:bind(updateFilter)()
end

function ImageFontText:cDraw()
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

return ImageFontText
