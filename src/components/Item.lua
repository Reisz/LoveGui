local Component = require "systems.Component"
local Property = require "systems.Property"

local Item = Component:new {
  Property("x", 0), Property("y", 0),
  Property("width", 0), Property("height", 0),
  Property("visible", true),
  Property("test", Component{})
}

function Item:draw()
  if not self.visible then return end
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  self:drawChildren()
  love.graphics.pop()
end

function Item:drawChildren()

end

return Item
