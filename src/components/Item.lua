local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Point = require "util.Point"
local Rect = require "Util.Rect"

local Item = class("Item")

function Item:initialize(tbl)
  property(self, tbl, "x", 0)
  property(self, tbl, "y", 0)

  property(self, tbl, "width", 0)
  property(self, tbl, "height", 0)

  self.rect = Rect(0, 0, 0, 0)
  component.binding(self.rect, "x", self.properties.x)
  component.binding(self.rect, "y", self.properties.y)
  component.binding(self.rect, "width", self.properties.width)
  component.binding(self.rect, "height", self.properties.height)

  property(self, tbl, "implicitWidth", 0)
  property(self, tbl, "implicitHeight", 0)

  property(self, tbl, "visible", true)

  property(self, tbl, "children", {})

  component.evalArgs(self, "children", tbl)
end

function Item:draw()
  if not self.visible then return end
  local children = self.children
  for i = #children, 1, -1 do
    local c = children[i]
    love.graphics.push()
    love.graphics.translate(c.x, c.y)
    c:draw()
    love.graphics.pop()
  end
end

function Item:update(dt)
  local children = self.children
  for i = 1, #children do
    children[i]:update(dt)
  end
end

function Item:childAt(x, y)
  local point = Point.resolveFunctionArgs(x, y)
  local children = self.children
  for i = #children, 1, -1 do
    if children[i]:conatins(point) then
      return children[i]
    end
  end
end

function Item:cointains(x, y)
  return self.rect:contains(x, y)
end

return component(Item)
