local class = require "lib.middleclass"

local Item = require "components.Item"

local Swap = class("Swap", Item)

Swap.property.index = 1

function Swap:cDraw()
  local i = self.index
  if self.children[i] then
    self.children[i]:draw()
  end
end

return Swap
