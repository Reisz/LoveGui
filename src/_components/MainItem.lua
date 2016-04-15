local class = require "lib.middleclass"

local Item = require "components.Item"

local MainItem = class("MainItem", Item)

MainItem.property.background:setMatcher("list(t.number, 3, 4)")
local function backgroundBinding(col)
  love.graphics.setBackgroundColor(col)
end

function MainItem:initialize()
  self.properties.background:bind(backgroundBinding)()
  love.draw = function() self:draw() end
  -- TODO implement resize as window resize
end

return MainItem
