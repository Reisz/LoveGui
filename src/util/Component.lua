local class = require "lib.middleclass"

local Proprerty = require "lib.property"

local Component = class("Component")


function Component.static:new(tbl)
  local info = string.match(debug.getinfo(3, "S").short_src, "([^%./\\]*)%..*$")
  local subclass = class(info, self)

  for i,v in pairs(tbl) do
    -- TODO instatiation logic
  end

  return subclass
end

return Component
