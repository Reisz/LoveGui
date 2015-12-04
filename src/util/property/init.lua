local e = require "util.property.error"
local matcher = require "util.matching"
local typeMatcher = require "util.matching.type"

local property = {}

local function set(self, value)
  if not self.type(value) then
    error(e.invalid_type:format(nil, nil), 4)
    -- TODO fix messages
  end

  local _v = self.value
  self.value = value
  if _v ~= value then self:notify(value) end
end

local function notify(self, value)
  local cb = self.callbacks
  for i = 1, #cb do cb[i](value) end
end

local function get(self)
  return self.value
end

function property.new(tbl, args, name, value, flags)
  local t = typeMatcher[type(value)]
  if flags then t = matcher(flags) end

  -- look for initial assignment
  local v = args[name]
  if v then
    if not t(v) then
      error(e.initial_type_invalid:format(name, nil, nil))
      -- TODO fix messages
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
