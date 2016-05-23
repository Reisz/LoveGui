local Relationship = {}

--------------------------------------------------------------------------------
-- Initialize / Subclass
--------------------------------------------------------------------------------
local function initialize(self, parent)
  self.parent = parent

  local children = {}; self.children = children
  for i,v in ipairs(self.static.children) do
    children[i] = v:new(self)
  end
end

local function subclassed(self, other)
  local children = {}; other.static.children = children
  for i,v in ipairs(self.static.children) do
    children[i] = v
  end
end

function Relationship:included(class)
  class.init.Relationship = initialize
  class.subc.Relationship = subclassed
  class.static.children = {}
end

--------------------------------------------------------------------------------
-- Static Methods
--------------------------------------------------------------------------------
function Relationship.static:addChild(child)
  table.insert(self.children, child)
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------

return Relationship
