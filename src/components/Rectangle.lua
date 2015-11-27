local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Item = require "components.Item"

local Rectangle = class("Rectangle", Item.class)

function Rectangle:initialize(tbl)
  property(self, tbl, "color", {255, 255, 255}, "table")

  Item.class.initialize(self, component.evalArgs(self, nil, tbl))
end

function Rectangle:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)
end

return component(Rectangle)
