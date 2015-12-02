local e = require "util.property.error"
local typeMatcher, check = require "util.property.type" ()

local property = {}

local function set(self, value)
  local t, _t = self.type, type(value)
  if not check(t, _t) then
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
  return self.value
end

function property.new(tbl, args, name, value, flags)
  local t = typeMatcher(value, flags)

  -- look for initial assignment
  local v = args[name]
  if v then
    local _t = type(v)
    if not check(t, _t) then
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
