local Property = {}

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function initialize(self)
  self.properties = {}
  self.matchers = {}
end

local function clone(self, other)
  -- enable clone on write
  other.properties = setmetatable({}, { __index = self.properties })
  other.matchers = setmetatable({}, { __index = self.matchers })
end

function Property:included(class)
  table.insert(class.mixin_initialize, initialize)
  table.insert(class.mixin_clone, clone)
end


--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
local function get(self, name)
  return self.properties[name] or (self.lists and self.lists[name])
end; Property.get = get

local function set(self, name, val)
  assert((self.lists and self.lists[name]) == nil,
    "Trying to overwrite existing list property!")

  local m = self.matchers[name]
  assert((m and m(val)) or (not m),
    "Invalid property value type!")

  self.properties[name] = val

  -- TODO notify
end; Property.set = set

function Property:setMatcher(name, matcher)
  self.matchers[name] = matcher
end

Property.__index = get
Property.__newindex = set

return Property
