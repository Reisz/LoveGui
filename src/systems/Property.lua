local debug = require "systems.debug"

local Property = {}
local _nil = function() end; Property._nil = _nil

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function initialize(self)
  self.properties = {}
  self._properties = {}
  self.matchers = {}
end

local function clone(self, other)
  -- enable clone on write for normal properties
  other.properties = setmetatable({}, { __index = self.properties })
  other.matchers = setmetatable({}, { __index = self.matchers })
  -- execute cloning on special properties
  other._properties = {}
  for i,v in pairs(self.lists) do
    other._properties[i] = v:clone()
  end
end

function Property:included(class)
  table.insert(class.mixin_initialize, initialize)
  table.insert(class.mixin_clone, clone)
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
local function _isProperty(self, name)
  return type(self.properties[name]) ~= "nil"
     and type(self.matchers[name]) ~= "nil"
end

local function _isSpecial(self, name)
  return type(self._properties[name]) ~= "nil"
end

local function hasProperty(self, name)
  return _isProperty(self, name) or _isSpecial(self, name)
end; Property.hasProperty = hasProperty

function Property:clear(name)
  if _isProperty(self, name) then
    self.properties[name] = nil
    self.matchers[name] = nil
  elseif _isSpecial(self, name) then
    self._properties[name] = nil
  else
    -- method goal still met -> print instead of assert
    debug.warn("Trying to clear non-existent property.")
  end
end

-- get property value or special property
function Property:get(name)
  local v = self.properties[name]
  if v then
    if v ~= _nil then
      return v
    end
  else
    return self._properties[name]
  end
end

-- get matcher for property or special property
function Property:getMatcher(name)
  local m = self.matchers[name]
  if not m then
    local s = self._properties[name]
    m = s and s:getMatcher()
  end
  return m
end

-- set matcher for property or special property
function Property:setMatcher(name, matcher)
  local s = self._properties[name]
  if s then
    s:setMatcher(matcher)
  else
    self.matchers[name] = matcher
  end
end

-- create new special property
-- wrappers must provide the following funcionality:
-- - initialize(self, object:Component, name:string)
-- - clone(self) : typeof(wrapper)
-- - setMatcher(self, matcher:Matcher)
-- - getMatcher(self, ) : Matcher
function Property:create(name, wrapper)
  assert(not hasProperty(self, name),
    "Trying to overwrite existing property.")
  self._properties[name] = wrapper:initialize(self, name)
end

-- set property to a value, fail on special properties
-- set("<name>", nil) will re-enable inheritance
function Property:set(name, val)
  -- prevent overwrites, so properties and special properties can share get()
  -- this allows __index to also work for special properties
  assert(not _isSpecial(self, name),
    "Trying to overwrite existing special property.")

  -- ensure type safety, if required
  local m = self.matchers[name]
  assert((not m) or m(val), "Invalid property value type.")

  -- actually set the value
  if type(val) == "nil" then val = _nil end
  self.properties[name] = val

  -- TODO notify
end

--------------------------------------------------------------------------------
-- Instance Metatable
--------------------------------------------------------------------------------
Property.__index = Property.get
Property.__newindex = Property.set

return Property
