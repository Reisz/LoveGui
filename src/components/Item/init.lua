local class = require "util.middleclass"
local matcher = require "util.matching"

local Component = require "util.Component"
local Point = require "util.Point"
local Rect = require "util.Rect"

local util = require "components.Item.util"
local Item = class("Item", Component)

Item.property.x = 0
Item.property.y = 0

Item.property.width = 0
Item.property.height = 0

Item.property.implicitWidth = 0
Item.property.implicitWidth:setMatcher("__")
Item.property.implicitHeight = 0
Item.property.implicitHeight:setMatcher("__")

Item.property.layer = Component.group{
  enabled = false, format = "normal", msaa = 0, wrapMode = "repeat",
  minFilter = "linear", magFilter = "linear", anisotropy = 1
}
Item.property.layer.format:setMatcher(util.getCanvasFormatMatcher())
Item.property.layer.shader:setMatcher("may(l2t.Shader)")
Item.property.layer.wrapMode:setMatcher(util.getWrapModeMatcher())
local filterMatcher = matcher("v{'linear', 'nearest'}")
Item.property.layer.minFilter:setMatcher(filterMatcher)
Item.property.layer.magFilter:setMatcher(filterMatcher)

Item.property.visible = true

Item.property.children = Component.default{}

function Item:initialize()
  self.rect = Rect(0, 0, 0, 0)
  self.properties.x:bindTo(self.rect, "x")()
  self.properties.y:bindTo(self.rect, "y")()
  self.properties.width:bindTo(self.rect, "width")()
  self.properties.height:bindTo(self.rect, "height")()
end

function Item:draw()
  if not self.visible then return end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  self:cDraw()
  love.graphics.pop()
end

function Item:cDraw()
  local children = self.children
  for i = #children, 1, -1 do
    children[i]:draw()
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

return Item
