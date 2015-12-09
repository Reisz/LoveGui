local matcher = require "util.matching"
local typeMatcher = require "util.matching.type"

local propertyInstance = require "util.Component.property_instance"
local groupInstance = require "util.Component.group_instance"

local propertyMethods = {}
function propertyMethods:setMatcher(m)
  if type(m) == "function" or matcher.isMatcher(m) then
    self.matcher = m
  else
    self.matcher = matcher(m)
  end
end

local property = {}
property.default = {}

local function _create(name, value)
  return setmetatable({name = name, value = value, matcher = typeMatcher[type(value)]},
    { __index = propertyMethods, __call = propertyInstance.new })
end

local group, default = {}, {}; local grouptbl = {[group] = true}
function property.create(name, value)
  local mt = value and getmetatable(value)
  if mt and mt[group] then
    local result = setmetatable({name = name},
      { __index = property.create__index, __call = groupInstance.new })
    for i, v in pairs(value) do result[i] = _create(i, v) end
    return result
  else
    local prop = _create(name, value)
    if mt and mt[default] then
      prop.isDefault = true
      mt[default] = nil
    end
    return prop
  end
end

function property.create__newindex(tbl, key, val)
  rawset(tbl, key, property.create(key, val))
end

function property.create__index(tbl, key)
  local p = property.create(key, nil)
  rawset(tbl, key, p)
  return p
end

-- this should always be called with a new table (maskGroup{...})
function property.maskGroup(tbl)
  return setmetatable(tbl, grouptbl)
end

-- this can have its own metatable
function property.maskDefault(val)
  local mt = getmetatable(val)
  if not mt then
    mt = {}
    setmetatable(val, mt)
  end
  mt[default] = true
  return val
end

return property
