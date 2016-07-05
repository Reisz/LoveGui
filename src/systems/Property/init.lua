local log = require "systems.log"
local Matcher = require "systems.Matcher"

local Property = {}
local _nil = function() end; Property._nil = _nil
-- _get_special allows certain values (usually unique function pointers) to
-- cause Property:get(name) to return someting other than the value itself
-- expects specialEvaluator(self:Component, name:string)
local _get_special = {}; Property._get_case = _get_special
_get_special[_nil] = function() return nil end

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function initialize(self)
  rawset(self, "properties", {})
  rawset(self, "_properties", {})
  rawset(self, "matchers", {})
end

local function clone(self, other)
  -- enable clone on write for normal properties
  rawset(other, "properties", setmetatable({}, { __index = self.properties }))
  rawset(other, "matchers", setmetatable({}, { __index = self.matchers }))
  -- execute cloning on special properties
  rawset(other, "_properties", {})
  for i,v in pairs(self._properties) do
    other._properties[i] = v:clone(self, other, i)
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
     or type(self.matchers[name]) ~= "nil"
end

local function _isObject(self, name)
  return type(self._properties[name]) ~= "nil"
end

local function hasProperty(self, name)
  return _isProperty(self, name) or _isObject(self, name)
end; Property.hasProperty = hasProperty

function Property:clear(name)
  if _isProperty(self, name) then
    self.properties[name] = nil
    self.matchers[name] = nil
  elseif _isObject(self, name) then
    self._properties[name] = nil
  else
    -- method goal still met -> print instead of assert
    log.warn("Trying to clear non-existent property.")
  end
end

-- get property value, evaluate special property or get object property
function Property:get(name)
  local v = self.properties[name]
  if v then
    -- if v represents a special value (nil, binding, ...)
    local s = _get_special[v]
    if s then return s(self, name)
    else return v end
  else
    return self._properties[name]
  end
end

-- get matcher for property or object property
function Property:getMatcher(name)
  local m = self.matchers[name]
  if not m then
    local s = self._properties[name]
    m = s and s:getMatcher()
  end
  return m
end

-- set matcher for property or object property
function Property:setMatcher(name, matcher)
  if type(matcher) == "string" then
    matcher = Matcher.new(matcher)
  end

  local s = self._properties[name]
  if s then
    s:setMatcher(matcher)
  else
    self.matchers[name] = matcher
  end
end

-- create new object property
-- wrappers must provide the following funcionality:
-- - initialize(self:class<ObjectProperty>, object:Component, name:string)
-- - clone(self:ObjectProperty, object:Component, other:Component name:string) : ObjectProperty
-- - setMatcher(self:ObjectProperty, matcher:Matcher)
-- - getMatcher(self:ObjectProperty) : Matcher
function Property:create(name, wrapper)
  assert(not hasProperty(self, name),
    "Trying to overwrite existing property.")
  -- allow wrappers to be identified by name
  if type(wrapper) == "string" then
    wrapper = require ("systems.Property." .. wrapper)
  end
  -- create a new wrapper instance
  local inst = wrapper:initialize(self, name)
  self._properties[name] = inst
  return inst
end

-- set property to a value, fail on object properties
-- set("<name>", nil) will re-enable inheritance
function Property:set(name, val)
  -- prevent overwrites, so properties and object properties can share get()
  -- this allows __index to also work for object properties
  assert(not _isObject(self, name),
    "Trying to overwrite existing object property.")

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
