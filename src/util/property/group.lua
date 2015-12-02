--- # Group Properties
--- Group properties are used for properties, where the user may want to change
--- multiple properties at the same time (e.g. font-family and size,
--- border width and color).
---
--- ## User Actions
--- When a group propetry is defined, the user has access to the following
--- actions:
---
--- ### Group Assignment
--- ```lua
--- Rectangle {
---   border = {
---     width = 2,
---     color = {0, 255, 0}
---   }
--- }
--- ```
--- Assigns the values on object creation, as long as types are correct. When
--- a subproperty is left out, it uses the default value or the value assigned
--- in a single assignment. Setting the value of a subproperty via single- and
--- group assignment at the same time will cause an error.
---
--- ### Single Assignment
--- ```lua
--- Rectangle {
---   border_width = 2,
---   border_color = {0, 255, 0}
--- }
--- ```
--- Assigns the values on object creation, as long as types are correct. When
--- a subproperty is left out, it uses the default value or the value assigned
--- in a group assignment. Setting the value of a subproperty via single- and
--- group assignment at the same time will cause an error.
---
--- ### Group change
--- ```lua
--- rectangle.border = {
---   width = 2,
---   color = {0, 255, 0}
--- }
--- ```
--- Changes every property that exists in the table, as long as types are
--- correct. Other properties are left untouched. This method is recommended
--- when changing multiple subproperties, as it only triggers bindings once.
---
--- ### Single change
--- ```lua
--- rectangle.border.width = 1
--- rectangle.border.color = {0, 255, 0}
--- ```
--- Changes a property that exists in the table, as long as the type is
--- correct. Other properties are left untouched. Only use this property when
--- a single subproperty has to be changed on its own, because each assignment
--- will tirgger all the bindings individually.
---
--- ### Group Lookup
--- ```lua
--- local border = rectangle.border
--- ```
--- Get a reference to a modifiable table containing all subproperties.
--- Keep in mind, that changing values in this table will aactually affect
--- the component itself and trigger bindings, because there is no way to
--- distinguish between this and a single change or a single lookup.
---
--- ### Single Lookup
--- ```lua
--- local color = rectangle.border.color
--- local width = rectangle.border.width
--- ```
--- Get the value of a specific subproperty.
local e = require "util.property.error"
local typeMatcher, check = require "util.property.type" ()

-- group assignment
local function set(self, value)
  local changed = false
  for i, t in pairs(self.types) do
    local _t = type(value[i])
    if not check(t, _t) then
      error(e.group_invalid_assignment:format(i, t, _t), 4)
    end
    if self.group[i] ~= value[i] then changed = true end
    self.group[i] = value[i]
  end

  if changed then self:notify(value) end
end

local function get_helper_newindex(tbl, key, val)
  local self = tbl[1]

  local t, _t = self.types[key], type(val)
  if not check(t, _t) then
    error(e.invalid_type:format(t, _t), 4)
  end

  local _v = self.group[key]
  self.group[key] = value
  if _v ~= value then self:notify(self.group) end
end

local function notify(self, value)
  local cb = self.callbacks
  for i = 1, #cb do cb[i](value) end
end

local function get_helper_index(tbl, key)
  return tbl[1].group[key]
end

local function get(self)
  return self.get_helper
end

local nilTable = {}
local nilCheck = { [nilTable] = true }

return function(tbl, args, name, group, flags)
  local types, _group = {}, args[name] or {}

  -- also include types that are nil by default
  for i, v in pairs(flags) do
    if not group[i] then group[i] = nilTable end
  end

  -- confirm all types and look for initial assignments
  for i, v in pairs(group) do
    local t = typeMatcher(v, flags and flags[i]); types[i] = t

    -- 2 types of initial assignment
    local v1, v2 = args[name .. "_" .. i], _group[i]
    if v1 and v2 then
      error(e.group_single_double:format(name, i), 5)
    elseif v2 then v1 = v2 end

    -- initial assignment is in v1
    if v1 then
      local _t = type(v1)
      if not check(t, _t) then
        error(e.group_initial_type_invalid:format(name, i, t, type(v1)), 5)
      end

      group[i] = v1
    end
    
    -- avoid custom __eq on empty tables
    if nilCheck[group[i]] then group[i] = nil end
  end

  -- create group property
  local g = { "group",
    group = group, types = types, callbacks = {},
    set = set, get = get, notify = notify
  }
  g.get_helper = setmetatable({g}, { __index = get_helper_index, __newindex = get_helper_newindex })

  -- add to component
  if not tbl.properties then tbl.properties = {} end
  tbl.properties[name] = g
end
