local propertyInstance = require "util.Component.property_instance"
local e = "Property %s.%s: New value %s did not match criteria."
local e_assign = "Ambiguous assignment: Property %s.%s unsing single- and double-assignment."

local groupInstance = {}

local function helper_index(tbl, key)
  return tbl[1].values[key]:get()
end

local function helper_newindex(tbl, key, val)
  local prop = tbl[1].values[key]
  local _v = prop:get()
  tbl[1].values[key]:set(val)
  if _v ~= val then tbl[1]:notify(tbl[1].values) end
end


local function __set(self, value, method)
  local changed = false
  for i, v in pairs(value) do
    local prop = self.values[i]
    local _v = prop:get()
    prop[method](prop, v)
    if v ~= _v then changed = true end
  end

  if changed then self:notify(self.values) end
end

local function set(self, value) __set(self, value, "set") end
local function _set(self, value) __set(self, value, "_set") end
local function get(self) return self.helper end

local empty = {}
function groupInstance:new(instance, args)
  local name, tbl = self.name, instance.properties

  -- manage values and assignment
  local _group, values = args[name] or empty, {}; args[name] = nil
  for i, v in pairs(self) do
    if i ~= "name" then
      local value = v.value

      -- 2 types of initial assignment
      local qualName = table.concat{name, "_", i}
      local v1, v2 = args[qualName], _group[i]; args[qualName] = nil
      if v1 and v2 then
        error(e_assign:format())
      elseif v2 then v1 = v2 end

      -- initial assignment is in v1
      if v1 then
        assert(v.matcher(v1), e:format(name, i, v1))
        value = v1
      end

      if type(value) == "table" and type(value.properties) == "table" then
        value.properties.parent:_set(tbl)
      end

      values[i] = propertyInstance.create(value, v.matcher)
    end
  end

  tbl[self.name] = groupInstance.create(values)
end

function groupInstance.create(values)
  local g = { values = values, callbacks = {}, set = set, _set = _set, get = get }
  require "util.Component.binding"(g)
  g.helper = setmetatable({g}, { __index = helper_index, __newindex = helper_newindex })
  setmetatable(g, { __index = g.values })
  return g
end


return setmetatable(groupInstance, { __call = function(_, ...) return groupInstance.new(...) end })
