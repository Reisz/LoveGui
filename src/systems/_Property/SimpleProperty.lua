local SimpleProperty = {}

--------------------------------------------------------------------------------
-- Internal
--------------------------------------------------------------------------------
local function new(tbl)
  return setmetatable(tbl, {
    __index = SimpleProperty
  })
end

function SimpleProperty:clone()
  local p = {}
  for i, v in pairs(self) do
    p[i] = v
  end
  return new(p)
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

--------------------------------------------------------------------------------
-- Constructor
--------------------------------------------------------------------------------
return function(name)
  return new {
    name = name,
    matcher = dummy
  }
end
