local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Item = require "components.Item"

local Text = class("Text", Item.class)

function Text:initialize(tbl)
  property(self, tbl, "text", "", "string")

  Item.class.initialize(self, component.evalArgs(self, nil, tbl))
end

function Text:draw()
  love.graphics.print(self.text, 0, 0)
end

return component(Text)
