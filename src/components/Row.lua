local class = require "util.middleclass"

local Item = require "components.Item"

local Row = class("Row", Item)

Row.property.spacing = 0

function Row:cDraw()
  local children, x, sp = self.children, 0, self.spacing
  for i = 1, #children do
    local c = children[i]
    local w = c:getWidth()
    if c.visible and w > 0 then
      love.graphics.push()
      love.graphics.translate(x, 0)
      c:cDraw()
      love.graphics.pop()
      x = x + w + sp
    end
  end
end

return Row
