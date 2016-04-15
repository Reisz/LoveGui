local class = require "lib.middleclass"

local Property = require "systems.Property"

local Component = class("Component")
Component:include(Property.mixin)

--- Create an anonymous subclass with updated property values and children list.
---
function Component.static:new(tbl)
  local subclass = class("Anonymous" .. self.name, self)
  subclass.static.properties = {}
  subclass.static.children = {}

  local len = #tbl
  for i,v in pairs(tbl) do
    if type(i) == "number" and i <= len then
      if type(v) == "table" and v.name then

      else
        print()
      end
    else -- change default property values
      local prop = self.properties[i]
      if prop then subclass.properties[i] = prop:clone(v)
      else print("Unknown property " .. self.name .. "." .. i) end
    end
  end

  return subclass
end

function Component.static:subclassed(other)

end

return Component
