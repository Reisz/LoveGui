local class = require "lib.middleclass"

local SimpleProperty = class("SimpleProperty")

--------------------------------------------------------------------------------
-- Internal
--------------------------------------------------------------------------------
function SimpleProperty:initialize(name)
  self.name = name
  self:setMatcher()
end


function SimpleProperty:clone()
  local p = SimpleProperty()
  for i,v in pairs(self) do p[i] = v end
  return p
end

function SimpleProperty:create()
  -- TODO
end

--------------------------------------------------------------------------------
-- Extrenal
--------------------------------------------------------------------------------
function SimpleProperty:get()
  return self.value
end

function SimpleProperty:set(value)
  self.value = value
  return self
end

local function dummy() return true end
function SimpleProperty:setMatcher(matcher)
  self.matcher = matcher or dummy
  return self
end

function SimpleProperty:getMatcher()
  return self.matcher
end

return SimpleProperty
