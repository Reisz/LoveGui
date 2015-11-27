local function set(self, value)
  assert(self.type == "" or type(value) == self.type)
  self.value = value
  self:notify(value)
end

local function notify(self, value)
  local cb = self.callbacks
  for i = 1, #cb do cb[i](value) end
end

local function get(self) return self.value end

return function(tbl, args, name, value, t)
  type = type or ""

  local v = args[name]
  if v then
    assert(type(v) == t)
    value = args[name]
  end

  if not tbl.properties then tbl.properties = {} end
  tbl.properties[name] = {
    "property",
    value = value, type = t,
    callbacks = {},
    set = set, get = get, notify = notify
  }
end
