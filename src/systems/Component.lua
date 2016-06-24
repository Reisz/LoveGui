local class = require "lib.middleclass"

--------------------------------------------------------------------------------
-- Class Def & Mixins
--------------------------------------------------------------------------------
local Component = class("Component")

local mixinTables = { "mixin_intialize", "mixin_subclassed", "mixin_clone" }
for _,v in ipairs(mixinTables) do Component.static[v] = {} end

Component:include(require "systems.Property")
--Component:include(require "systems.ListProperty")
--Component:include(require "systems.Relationship")
--Component:include(require "systems.Querying")

--------------------------------------------------------------------------------
-- Delegate behavior to mixins
--------------------------------------------------------------------------------

function Component:initialize(parent)
  -- initlialize mixins
  for _,v in ipairs(self.mixin_intialize) do
    v(self, parent)
  end
end

function Component.static:subclassed(other)
  -- inherit mixin methods
  for _,v in ipairs(mixinTables) do
    other.static[v] = setmetatable({}, { __index = self[v] })
  end

  -- do mixin subclassing
  for _,v in ipairs(self.mixin_subclassed) do
    v(self, other)
  end
end

function Component:clone()
  local other = self.class:allocate()

  -- do mixin subclassing
  for _,v in ipairs(self.mixin_clone) do
    v(self, other)
  end
end

return Component
