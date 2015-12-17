local propertyInstance = {}
local e = "Property %s: New value %s did not match criteria."

function propertyInstance:new(tbl, args, canDefault)
  -- manage value and assignment
  local value, v = self.value, args[self.name]
  if v then
    assert(self.matcher(v), e:format(self.name, v))
    value = v; args[self.name] = nil
  end

  if value ~= v and type(value) == "table" then
    local mt = getmetatable(value)
    local _v = value; value = {}
    for i, val in pairs(_v) do
      value[i] = val
    end
    setmetatable(value, mt)
  end

  local prop = propertyInstance.create(value, self.matcher)
  tbl[self.name] = prop
  if canDefault and self.isDefault then tbl.default = prop end
end

function propertyInstance.create(value, matcher)
  return setmetatable({value = value, matcher = matcher, callbacks = {}}, { __index = propertyInstance })
end

function propertyInstance:set(value)
  assert(self.matcher(value), e:format(self.name, value))
  self:_set(value)
end

function propertyInstance:_set(value)
  local _v = self.value
  self.value = value
  if _v ~= value then self:notify(value) end
end

function propertyInstance:get() return self.value end

require "util.Component.binding"(propertyInstance)

return setmetatable(propertyInstance, { __call = function(_, ...) return propertyInstance.new(...) end })
