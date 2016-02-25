local class = require "util.middleclass"

local StringBuilder = class("StringBuilder")

function StringBuilder:initialize(...)
  self.content = {...}
end

function StringBuilder:append(...)
  for i = 1, select("#", ...) do
    table.insert(self.content, (select(i, ...)))
  end
  return self
end

function StringBuilder:__tostring()
  local result = table.concat(self.content)
  self.content = {result}
  return result
end

return StringBuilder
