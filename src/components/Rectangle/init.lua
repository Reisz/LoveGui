local class = require "lib.middleclass"
local matcher = require "util.matching"

local fill = require "components.Rectangle.fill"
local line = require "components.Rectangle.line"

local Item = require "components.Item"

local Rectangle = class("Rectangle", Item)
local colMatcher = matcher("tbl{t.number, t.number, t.number, may(t.number)}")

Rectangle.property.border = Item.group {
  color = {0, 0, 0}, width = 0
}
Rectangle.property.border.color:setMatcher(colMatcher)

Rectangle.property.color = {255, 255, 255}
Rectangle.property.color:setMatcher(colMatcher)
Rectangle.property.gradient:setMatcher("may(o.Gradient)")

Rectangle.property.radius = 0
Rectangle.property.radiusSegments = 0

function Rectangle:initialize()
  Item.initialize(self)
  self.properties.radius:bindTo(self, "radiusSegments")()
end

function Rectangle:cDraw()
  -- fill (with gradient)
  if self.gradient then self.gradient:prepare(self.width, self.height) end
  love.graphics.setColor(self.color)
  fill(self.width, self.height, self.radius, self.radiusSegments)
  if self.gradient then self.gradient:apply(self.width, self.height) end

  -- border
  if self.border.width > 0 then
    love.graphics.setColor(self.border.color)
    love.graphics.setLineWidth(self.border.width)
    line(self.width, self.height, self.radius, self.radiusSegments)
  end

  -- children
  Item.cDraw(self)
end

return Rectangle
