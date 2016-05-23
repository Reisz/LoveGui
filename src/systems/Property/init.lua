local SimpleProperty = require "systems.Property.SimpleProperty"
local GroupProperty = require "systems.Property.GroupProperty"
local ListProperty = require "systems.Property.ListProperty"

local Property = {}

--------------------------------------------------------------------------------
-- Initialize / Subclass
--------------------------------------------------------------------------------
local function initialize(self)
  local properties = {}; self.properties = properties
  for i,v in pairs(self.static.properties) do
    properties[i] = v:create()
  end
end

-- autoclone properties on lookup
local function property__index(tbl, key)
  local p = getmetatable(tbl)[property__index][key]
  if p then
    p = p:clone(); tbl[key] = p
    return p
  end
end

-- setup autoclone functionality
local function subclassed(self, other)
  other.static.properties = setmetatable({}, {
    [property__index] = self.static.properties,
    __index = property__index
  })
end

function Property:included(class)
  class.init.Property = initialize
  class.subc.Property = subclassed

end

--------------------------------------------------------------------------------
-- Static Methods
--------------------------------------------------------------------------------
function Property.static:addProperty(name)
  local p = SimpleProperty(name); self.properties[name] = p
  return p
end

function Property.static:addGroup(name)
  local p = GroupProperty(name); self.properties[name] = p
  return p
end

function Property.static:addList(name)
  local p = ListProperty(name); self.properties[name] = p
  return p
end

function Property.static:property(name)
  return self.properties[name]
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
function Property.__index(tbl, key)
  local p = tbl.properties[key]
  if p then return p:get() end
end

function Property.__newindex(tbl, key, val)
  local p = tbl.properties[key]
  if p then p:set(val) end
  -- TODO error message ?
end

return Property
