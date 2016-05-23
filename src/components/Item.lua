local Component = require "systems.Component"

local Item = Component:subclass("Item")

Item:addProperty("x", 0)
Item:addProperty("y", 0)
Item:addProperty("width", 0)
Item:addProperty("height", 0)

Item:addProperty("visible", true)

Item:addProperty("animations", {}):match("List{}")

function Item:draw()
  if not self.visible then return end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  self:drawChildren()
  love.graphics.pop()
end

function Item:drawChildren()
  local children = self.children
  for i = 1, #children do
    children[i]:draw()
  end
end

function Item:update(dt)
  local children = self.children
  for i = 1, #children do
    children[i]:update(dt)
  end
end

return Item
