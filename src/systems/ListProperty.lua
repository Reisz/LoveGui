local list = require "lib.list"

-- Requires Property mixin to be included
local ListProperty = {}

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function initialize(self)
  self.lists = {}
end

local function clone(self, other)
  -- enable clone on write
  other.lists = setmetatable({}, { __index = self.lists })
end

function ListProperty:included(class)
  table.insert(class.mixin_initialize, initialize)
  table.insert(class.mixin_clone, clone)
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
function ListProperty:createList(name)
  assert(self.properties[name] == nil,
    "Trying to overwrite existing property with list!")
  local l = {}; self.lists[name] = l
end

local dummy = function() return true end
function ListProperty:addTo(name, ...)
  local l = self.lists[name]
  local n, m = #l, self.matchers[name] or dummy
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    assert(m(v), "Invalid list property value type!")
    l[i + n] = v
  end

  -- TODO notify
end

function ListProperty:removeFrom(name, val)
  local l = self.lists[name]
  if l then list.removeOne(l, val) end
end

function ListProperty:removeAllFrom(name, val)
  local l = self.lists[name]
  if l then list.removeAll(l, val) end
end

return ListProperty
