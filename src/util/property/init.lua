local e = require "util.property.error"
local tables = require "util.tables"

local property = {}

local function set(self, value)
  local t, _t = self.type, type(value)
  if t ~= "" and t ~= _t then
    error(e.invalid_type:format(t, _t), 4)
  end

  self.value = value
  self:notify(value)
end

local function notify(self, value)
  local cb = self.callbacks
  for i = 1, #cb do cb[i](value) end
end

local function get(self)
  local v = self.value
  if type(v) == "table" then
    return tables.shallowCopy(v)
  end
  return v
end

function property.new(tbl, args, name, value, ignoreType)
  t = ignoreType and "" or type(value)

  -- look for initial assignment
  local v = args[name]
  if v then
    local _t = type(v)
    if t ~= "" and t ~= _t then
      error(e.initial_type_invalid:format(name, t, _t))
    end

    value = args[name]
  end

  -- create property
  if not tbl.properties then tbl.properties = {} end
  tbl.properties[name] = { "property",
    value = value, type = t, callbacks = {},
    set = set, get = get, notify = notify
  }
end

property.group = require "util.property.group"

return setmetatable(property, { __call = function(_, ...) property.new(...) end })
