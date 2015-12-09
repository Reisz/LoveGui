local class = require "util.middleclass"
local matcher = require "util.matching"

local Item = require "components.Item"

local Text = class("Text", Item)

-- TODO markdown support
Text.property.text = ""
Text.property.baseUrl = ""

Text.property.font = Item.group {
  family = "", size = 12,
  bold = false, italic = false, strikeout = false, underline = false
}

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

function Text:initialize(tbl)
  self.properties.font:bind(function(font)
    if font.family ~= "" then
      -- TODO font family / font style
      error("Font Management not yet Implemented")
    else
      self._font = love.graphics.newFont(font.size)
    end
  end)()
end

function Text:cDraw()
  love.graphics.setColor(self.color)
  love.graphics.setFont(self._font)
  love.graphics.print(self.text, 0, 0)
end

return Text
