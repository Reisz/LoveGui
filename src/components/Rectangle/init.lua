local pi, halfPi = math.pi, math.pi / 2

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
  property(self, tbl, "radius", 0)
  property(self, tbl, "radiusSegments", self.properties.radius:get())
  component.binding(self, "radiusSegments", self.properties.radius)

  Item.class.initialize(self, component.evalArgs(self, nil, tbl))
end

local function fill(width, height, radius, segments)
  if radius > 0 then
    local innerWidth, innerHeight = width - 2 * radius, height - 2 * radius
    -- center, top, bottom, left, right
    --[[love.graphics.rectangle("fill", radius, radius, width - radius, height - radius)
    love.graphics.rectangle("fill", radius, 0, innerWidth, radius)
    love.graphics.rectangle("fill", radius, radius + innerHeight, innerWidth, radius)
    love.graphics.rectangle("fill", 0, radius, radius, innerHeight)
    love.graphics.rectangle("fill", radius + innerWidth, radius, radius, innerHeight)]]

    -- topleft, topright, bottomleft, bottomright
    love.graphics.arc("fill", radius, radius, radius, pi, pi + halfPi, segments)
    love.graphics.arc("fill", width - radius, radius, radius, -halfPi, 0, segments)
    love.graphics.arc("fill", radius, height - radius, radius, halfPi, pi, segments)
    love.graphics.arc("fill", width - radius, height - radius, radius, 0, halfPi, segments)
  else
    love.graphics.rectangle("fill", 0, 0, width, height)
  end
end

function Rectangle:draw()
  --[[love.graphics.setColor(self.color)
  fill(self.width, self.height, self.radius, self.radiusSegments)

  love.graphics.setColor(self.border.color)
  love.graphics.setLineWidth(self.border.width)]]
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)
  if self.border.width > 0 then
    love.graphics.setColor(self.border.color)
    love.graphics.setLineWidth(self.border.width)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)
  end
end

return component(Rectangle)
