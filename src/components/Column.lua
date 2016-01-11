local class = require "util.middleclass"

local Item = require "components.Item"

local Column = class("Column", Item)

Column.property.spacing = 0

function Column:cDraw()
  local children, y, sp = self.children, 0, self.spacing
  for i = 1, #children do
    local c = children[i]
    local h = c:getHeight()
    if c.visible and h > 0 then
      love.graphics.push()
      love.graphics.translate(0, y)
      c:cDraw()
      love.graphics.pop()
      y = y + h + sp
    end
  end
end

return Column
