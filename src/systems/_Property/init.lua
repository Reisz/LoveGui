local SimpleProperty = require "systems.Property.SimpleProperty"
local GroupProperty = {} --require "systems.Property.GroupProperty"
local ListProperty = {} --require "systems.Property.ListProperty"

local Property = {}

--------------------------------------------------------------------------------
-- Initialize / Subclass
--------------------------------------------------------------------------------
local function initialize(self)
  self.properties = {}
end

-- autoclone properties on lookup
local function property__index(tbl, key)
  local p = getmetatable(tbl)[property__index][key]
  if p then
    p = p:clone()
    tbl[key] = p
    return p
  end
end

-- setup autoclone functionality
local function clone(self, other)
  other.properties = setmetatable({}, {
    -- REVIEW compare performance to closures
    [property__index] = self.properties,
    __index = property__index
  })
end

function Property:included(class)
  class.init.Property = initialize
  class.clone.Property = clone
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
local function add(self, name, prop)
  self.properties[name] = prop
  return prop
end

function Property:addProperty(name)
  return add(SimpleProperty(name))
end

function Property:addGroup(name)
  return add(GroupProperty(name))
end

function Property:addList(name)
  return add(ListProperty(name))
end

function Property:property(name)
  return self.properties[name]
end

function Property:removeProperty(name)
  self.properties[name] = nil
end

function Property.__index(tbl, key)
  local p = tbl.properties[key]
  if p then
    return p:get()
  end
end

local err_set_unkown = "Trying to set unknown property %s on object %s (%s)."
function Property.__newindex(tbl, key, val)
  local p = tbl.properties[key]
  if p then
    p:set(val)
  else
    error(string.format(err_set_unkown, key, tbl.id, tbl))
  end
end

return Property
