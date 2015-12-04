local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local fill = require "components.Rectangle.fill"
local line = require "components.Rectangle.line"

local Item = require "components.Item"

local Rectangle = class("Rectangle", Item.class)

function Rectangle:initialize(tbl)
  property.group(self, tbl, "border", {
    color = {0, 0, 0},
    width = 0
  })
  property(self, tbl, "color", {255, 255, 255})
  -- TODO gradient (properties expecting component)
  property(self, tbl, "radius", 0)
  property(self, tbl, "radiusSegments", self.radius)
  component.binding(self, "radiusSegments", self.properties.radius)

  Item.class.initialize(self, tbl)
end

function Rectangle:draw()
  love.graphics.setColor(self.color)
  fill(self.width, self.height, self.radius, self.radiusSegments)

  if self.border.width > 0 then
    love.graphics.setColor(self.border.color)
    love.graphics.setLineWidth(self.border.width)
    line(self.width, self.height, self.radius, self.radiusSegments)
  end
end

return component(Rectangle)
