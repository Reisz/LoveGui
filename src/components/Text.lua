local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"
local matcher = require "util.matching"

local Item = require "components.Item"

local Text = class("Text", Item.class)

-- TODO markdown support

function Text:initialize(tbl)
  property(self, tbl, "text", "")
  property(self, tbl, "baseUrl", "")

  property.group(self, tbl, "font", {
    family = "", size = 12,
    bold = false, italic = false, strikeout = false, underline = false,
  })
  component.functionBinding(function(font)
    if font.family ~= "" then
      -- TODO font family / font style
      error("Font Management not yet Implemented")
    else
      self._font = love.graphics.newFont(font.size)
    end
  end, self.properties.font)()

  property(self, tbl, "lineHeight", 1.0)

  local colMatcher = matcher("tbl{t.number, t.number, t.number, may(t.number)}")
  property(self, tbl, "color", {0, 0, 0}, colMatcher)
  property(self, tbl, "linkColor", {0,0,238}, colMatcher)

  property(self, tbl, "plainText", false) -- TODO automatic plain text check

  property(self, tbl, "wrapMode", "NoWrap", "v{'NoWrap', 'WordWrap', 'WrapAnywhere'}")

  property(self, tbl, "horizontalAlignment", "left", "v{'left', 'right', 'center', 'justify'}")
  property(self, tbl, "verticalAlignment", "top", "v{'top', 'center', 'bottom'}")

  Item.class.initialize(self, tbl)
end

function Text:draw()
  love.graphics.setColor(self.color)
  love.graphics.setFont(self._font)
  love.graphics.print(self.text, 0, 0)
end

return component(Text)
