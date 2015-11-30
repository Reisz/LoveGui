local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Item = require "components.Item"

local Rectangle = class("Rectangle", Item.class)

function Rectangle:initialize(tbl)
  property.group(self, tbl, "border", {
    color = {0, 0, 0},
    width = 0
  })
  property(self, tbl, "color", {255, 255, 255})

  Item.class.initialize(self, component.evalArgs(self, nil, tbl))
end

function Rectangle:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)
  if self.border.width > 0 then
    love.graphics.setColor(self.border.color)
    love.graphics.setLineWidth(self.border.width)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)
  end
end

return component(Rectangle)
