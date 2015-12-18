local class = require "util.middleclass"
local matcher = require "util.matching"

local Item = require "components.Item"
local Font = require "util.Font"

local Text = class("Text", Item)

-- TODO markdown support
Text.property.text = ""
Text.property.baseUrl = ""

Text.property.font = Item.group {
  family = "", size = 12, minFilter = "linear", magFilter = "linear", anisotropy = 1,
  bold = false, italic = false, strikeout = false, underline = false
}
local filterMatcher = matcher("v{'linear', 'nearest'}")
Text.property.font.minFilter:setMatcher(filterMatcher)
Text.property.font.magFilter:setMatcher(filterMatcher)

-- TODO find better solution
Text.property.orientation = 0
Text.property.scale = 1
Text.property.scale:setMatcher("any{t.number, tbl{t.number, t.number}}")
Text.property.offsetX = 0
Text.property.offsetY = 0
Text.property.shearX = 0
Text.property.shearY = 0

Text.property.lineHeight = 1.0

local colMatcher = matcher("tbl{t.number, t.number, t.number, may(t.number)}")
Text.property.color = {0,0,0}
Text.property.color:setMatcher(colMatcher)
Text.property.linkColor = {0,0,238}
Text.property.linkColor:setMatcher(colMatcher)

Text.property.plain = false -- TODO automatic plain text check

Text.property.wrapMode = "NoWrap"
Text.property.wrapMode:setMatcher("v{'NoWrap', 'WordWrap', 'WrapAnywhere'}")

Text.property.horizontalAlignment = "left"
Text.property.horizontalAlignment:setMatcher("v{'left', 'right', 'center', 'justify'}")
Text.property.verticalAlignment = "top"
Text.property.verticalAlignment:setMatcher("v{'top', 'center', 'bottom'}")

function Text:initialize()
  Item.initialize(self)
  self._font = Font(self.font.family, self.font.size,self.font.bold and 75 or 50, self.font.italic)
  self.properties.font.family:bind(function(f) self._font:setFamily(f) end)
  self.properties.font.bold:bind(function(b) self._font:setWeight(b and 75 or 50) end)
  self.properties.font.italic:bind(function(i) self._font:setItalic(i) end)
  self.properties.font.minFilter:bindTo(self._font, "minFilter")()
  self.properties.font.magFilter:bindTo(self._font, "magFilter")()
  self.properties.font.anisotropy:bindTo(self._font, "anisotropy")()
end

function Text:cDraw()
  local scaleX, scaleY = self.scale, self.scale
  if type(scaleX) == "table" then
    scaleX = scaleX[1]
    scaleY = scaleY[2]
  end

  love.graphics.setColor(self.color)
  self._font:print(self.text, 0, 0, self.orientation, scaleX, scaleY,
    self.offsetX, self.offsetY, self.shearX, self.shearY)
end

return Text
