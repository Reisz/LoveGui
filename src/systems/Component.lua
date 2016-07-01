local class = require "lib.middleclass"

--------------------------------------------------------------------------------
-- Class Def & Mixins
--------------------------------------------------------------------------------
local Component = class("Component")

local mixinTables = { "mixin_initialize", "mixin_subclassed", "mixin_clone" }
for _,v in ipairs(mixinTables) do Component.static[v] = {} end

Component:include(require "systems.Property")
Component:include(require "systems.Relationship")
--Component:include(require "systems.Querying")
--Component:include(require "systems.Observer")

--------------------------------------------------------------------------------
-- Delegate behavior to mixins
--------------------------------------------------------------------------------
function Component:initialize(parent)
  -- initlialize mixins
  for _,v in ipairs(self.class.mixin_initialize) do
    v(self, parent)
  end
end

function Component.static:subclassed(other)
  -- inherit mixin methods
  for _,mixin_name in ipairs(mixinTables) do
    local tbl = {}; other.static[mixin_name] = tbl
    for i,v in ipairs(self[mixin_name]) do
      tbl[i] = v
    end
  end

  -- do mixin subclassing
  for _,v in ipairs(self.mixin_subclassed) do
    v(self, other)
  end
end

function Component:clone()
  local other = self.class:allocate()

  -- do mixin subclassing
  for _,v in ipairs(self.class.mixin_clone) do
    v(self, other)
  end

  return other
end

return Component
