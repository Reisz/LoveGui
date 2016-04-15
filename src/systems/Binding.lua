local class = require "lib.middleclass"
local Set = require "util.set"

local Binding = class("Binding")

function Binding:initlialize()

end

local function updateBindings(property, target)
  property.boundTo = target
  for p in proeprty.bindings:it() do
    updateBindings(p, target)
  end
end

function Property:bindTo(other)
  updateBindings(self, other.boundTo or other)
  other.bindings:insert(self)
end

local function removeBinding(self, oldTarget)
  self.boundTo = nil
  oldTarget.bindings:remove(self)
  for p in self.bindings:it() do
    updateBindings(p, self)
  end
end


function Property:set(v)
  local oldTarget = self.boundTo
  if oldTarget then removeBinding(self, oldTarget) end
end
