local class = require "lib.middleclass"

local PropertyInstance = require "systems.Property.PropertyInstance"
local GroupInstance = require "systems.Property.GroupPropertyInstance"

local Property = class("Property")

local mixin = {}
Property.static.mixin = mixin

function mixin:__index(key)
  local property = self.properties[key]
  return property and property:get()
end

function mixin:__newindex(key, val)
  local property = self.properties[key]
  if property then property:set(val)
  else error("Unknown property: " .. key) end
end

function mixin:setAnimation(name, easing, duration)
  local property = self.properties[name]
  assert(getmetatable(property) ~= GroupInstance)
  property.easing, property.duration = easing, duration
  if easing then setmetatable(property, AnimatedPropertyInstance)
  else setmetatable(property, PropertyInstance) end
end

local function noMatcher() return true end
function mixin:setMatcher(name, matcher)
  self.properties[name].matcher = matcher or noMatcher
end

function mixin:bind(name, object, otherName)
  local property = self.properties[name]
  assert(getmetatable(property) ~= GroupInstance)
end

function Property:initialize(name, default)

end

function Property:clone(newValue)

end

function Property:match(matcher)

end

function Property:animate(easing, duration)

end

function Property:createInstance(parent)

end

return Property
