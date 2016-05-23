local class = require "lib.middleclass"

--------------------------------------------------------------------------------
-- Mixin preparation
--------------------------------------------------------------------------------
local Component = class("Component")
Component.static.init, Component.static.subc = {}, {}

function Component:initialize(parent)
  -- update inherited properties before anything else
  if self.class.super and self.class.super.initialize then
    self.class.super.initialize(self, parent)
  end

  -- initlialize mixins
  for _,v in pairs(self.init) do
    v(self, parent)
  end
end

function Component.static:subclassed(other)
  -- inherit mixin methods
  other.static.init = setmetatable({}, { __index = self.init })
  other.static.subc = setmetatable({}, { __index = self.init })

  -- do mixin subclassing
  for _,v in pairs(self.subc) do
    v(self, other)
  end
end

--------------------------------------------------------------------------------
-- Default Mixins
--------------------------------------------------------------------------------
Component:include(require "systems.Property")

return Component
