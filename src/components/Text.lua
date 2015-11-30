local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Item = require "components.Item"

local Text = class("Text", Item.class)

function Text:initialize(tbl)
  property(self, tbl, "text", "")

  property(self, tbl, "color", {0, 0, 0})

  Item.class.initialize(self, component.evalArgs(self, nil, tbl))
end

function Text:draw()
  love.graphics.setColor(self.color)
  love.graphics.print(self.text, 0, 0)
end

return component(Text)
