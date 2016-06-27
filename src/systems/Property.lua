local Property = {}

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function initialize(self)
  self.properties = {}
  self.lists = {}
  self.matchers = {}
end

local function copyListOnRead(tbl, key)

end

local function clone(self, other)
  -- enable clone on write
  other.properties = setmetatable({}, { __index = self.properties })
  other.matchers = setmetatable({}, { __index = self.matchers })
  other.lists = setmetatable({}, { __index = copyListOnRead })
end

function Property:included(class)
  table.insert(class.mixin_initialize, initialize)
  table.insert(class.mixin_clone, clone)
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
local function hasList(self, name)
  return type(self.lists[name]) == "table"
end; Property.hasList = hasList

local function hasProperty(self, name)
  return type(self.properties[name]) ~= "nil"
     and type(self.matchers[name]) ~= "nil"
end; Property.hasProperty = hasProperty

-- get property value or list wrapper
local function get(self, name)
  return self.properties[name] or self.lists[name]
end; Property.get = get

function Property:setMatcher(name, matcher)
  if hasList(self, name) then
    self.lists[name].matcher = matcher
  else
    self.matchers[name] = matcher
  end
end

function Property:getMatcher(name)
  if hasList(self, name) then
    return self.lists[name].matcher
  else
    return self.matchers[name]
  end
end



function ListProperty:list(name)
  local l = self.lists[name]

  if not l then
    assert(not hasProperty(self, name),
      "Trying to overwrite existing property with list!")
    -- l = list.wrap()
    self.lists[name] = l
  end

  return l
end

local function dummy() return true end
local function set(self, name, val)
  -- prevent overwrites, because properties and list properties share the get()
  -- function, this allows __index to also work on lists
  assert(not hasList(self, name), "Trying to overwrite existing list property!")

  -- ensure type safety if required
  local m = self.matchers[name] or dummy
  assert(m(val), "Invalid property value type!")

  self.properties[name] = val

  -- TODO notify
end; Property.set = set

Property.__index = get
Property.__newindex = set

return Property
