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
local matcher = require "util.matching"
local typeMatcher = require "util.matching.type"

-- group assignment
local function set(self, value)
  local changed = false
  for i, t in pairs(self.types) do
    if not t(value[i]) then
      error(e.group_invalid_assignment:format(i, nil, nil), 4)
      -- TODO fix messages
    end
    if self.group[i] ~= value[i] then changed = true end
    self.group[i] = value[i]
  end

  if changed then self:notify(value) end
end

local function get_helper_newindex(tbl, key, val)
  local self = tbl[1]

  if not self.types[key](val) then
    error(e.invalid_type:format(nil, nil), 4)
    -- TODO fix messages
  end

  local _v = self.group[key]
  self.group[key] = val
  if _v ~= val then self:notify(self.group) end
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
  if flags then
    for i in pairs(flags) do
      if not group[i] then group[i] = nilTable end
    end
  end

  -- confirm all types and look for initial assignments
  for i, v in pairs(group) do
    local t, f = typeMatcher[type(v)], flags and flags[i]
    if f then t = matcher(f) end

    -- 2 types of initial assignment
    local v1, v2 = args[name .. "_" .. i], _group[i]
    if v1 and v2 then
      error(e.group_single_double:format(name, i), 5)
    elseif v2 then v1 = v2 end

    -- initial assignment is in v1
    if v1 then
      if not t(v1) then
        error(e.group_initial_type_invalid:format(name, i, nil, nil), 5)
        -- TODO fix messages
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
  tbl.properties[name] = g
end
