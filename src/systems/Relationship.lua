-- requires Property mixin to be applied
local Relationship = {}

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function cMatch(v)
  return type(v) == "table" and type(v.class) == "table" and
    v.class.name == "Component"
end

local function initialize(self, parent)
  self:create("_children", "set")
  self:setMatcher("_children", cMatch)
  if parent then parent:addChild(self) end
end

function Relationship:included(class)
  table.insert(class.mixin_initialize, initialize)
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
function Relationship:addChild(...)
  self._children:add(...)
end

function Relationship:removeChild(...)
  self._children:rem(...)
end

function Relationship:hasChild(child)
  return self._children:has(child)
end

function Relationship:children()
  return self._children:it()
end

return Relationship
