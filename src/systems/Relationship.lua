local list = require "lib.list"

local Relationship = {}

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function initialize(self, parent)
  self.parent = parent
  self.children = {}
end

local function clone(self, other)
  local children = {}
  for i,v in ipairs(self.children) do
    children[i] = v:clone()
  end
  other.children = children
end

function Relationship:included(class)
  class.init.Relationship = initialize
  class.clone.Relationship = clone
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
function Relationship:setParent(parent)
  -- clear old parent
  local oldParent = self.parent
  if oldParent then
    list:removeOne(oldParent.children, self)
  end

  -- add new parent
  if parent ~= oldParent then
    self.parent = parent
    table.insert(parent.children, self)
  end
end

-- TODO reimplement context functionality

return Relationship
