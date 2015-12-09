local class = require "util.middleclass"
local property = require "util.Component.property"

local Component = class("Component")

-- handles property and standard member access
local function __index(self, key)
  if self.properties[key] then
    return self.properties[key]:get()
  else
    return self.class.__instanceDict[key]
  end
end

-- handles property writing and property/defined signal access and standard member writing
local function __newindex(self, key, value)

  -- TODO signal access parsing

  if self.properties[key] then
    self.properties[key]:set(value)
  else
    rawset(self, key, value)
  end
end

-- overwrite middleclass Object:new
function Component:new(tbl)
  local instance = self:allocate()

  -- setup properties
  rawset(instance, "properties", {})

  local klass = self
  while klass.property do
    for i, v in pairs(klass.property) do
      v(instance.properties, tbl, klass == self)
    end
    klass = klass.super
  end

  local default = instance.properties.default
  if default then
    default = default:get()
    for i = 1, #tbl do
      table.insert(default, tbl[i])
    end
  end

  instance:initialize()
  return instance
end

function Component:subclassed(other)
  other.static.property = setmetatable({}, {
    __index = property.create__index,
    __newindex = property.create__newindex
  })
  other.__instanceDict.__index = __index
  other.__instanceDict.__newindex = __newindex
end

Component.static.group = property.maskGroup
Component.static.default = property.maskDefault

return Component
