-- handles property and standard member access
local function __index(tbl, key)
  local inst = getmetatable(tbl).instance
  if inst.properties[key] then
    return inst.properties[key]:get()
  else
    return inst[key]
  end
end

-- handles property writing and property/defined signal access and standard member writing
local function __newindex(tbl, key, value)
  local inst = getmetatable(tbl).instance

  -- TODO signal access parsing

  if inst.properties[key] then
    inst.properties[key]:set(value)
  else
    inst[key] = value
  end
end

local function newInstance(tbl, data)
  return setmetatable({}, {
    instance = tbl.class:new(data),
    __index = __index,
    __newindex = __newindex
  })
end

local component = {}

-- each class must have the public tables: properties
function component.createComponent(class)
  return setmetatable( {class = class}, { __call = newInstance, __index = class })
end

function component.binding(tbl, field, property)
  local fn = function(value) tbl[field] = value end
  table.insert(property.callbacks, fn)
  return function() fn(property:get()) end
end

function component.functionBinding(fn, property)
  table.insert(property.callbacks, fn)
  return function() fn(property:get()) end
end

function component.evalArgs(tbl, defaultProp, args)
  local def = defaultProp and tbl.properties[defaultProp]:get() or {}
  for i = 1, #args do
    table.insert(def, args[i])
    args[i] = nil
  end

  return args
end

return setmetatable(component, { __call = function(_, ...) return component.createComponent(...) end })
