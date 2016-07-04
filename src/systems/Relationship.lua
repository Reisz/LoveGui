-- requires Property mixin to be applied
local Relationship = {}

--------------------------------------------------------------------------------
-- Initialize / Clone
--------------------------------------------------------------------------------
local function cMatch(v)
  if type(v) == "nil" then return true end
  return type(v) == "table" and type(v.class) == "table" and
    v.class.name == "Component"
end

local function initialize(self, parent)
  self:setMatcher("_parent", cMatch)
  self:create("_children", "set")
  self:setMatcher("_children", cMatch)
  self:setParent(parent)
end

function Relationship:included(class)
  table.insert(class.mixin_initialize, initialize)
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
function Relationship:setParent(parent)
  -- clear old parent
  local oldParent = self._parent
  if oldParent then
    oldParent._children:rem(self)
  end

  -- add new parent
  if parent ~= oldParent then
    self._parent = parent
    parent._children:add(self)
  end
end

function Relationship:getParent()
  return self._parent
end

function Relationship:hasChild(c)
  return self._children:has(c)
end

function Relationship:addChild(child)
  child:setParent(self)
end

function Relationship:removeChild(child)
  if child._parent == self then
    child._parent = nil
  end
  self._children:rem(child)
end

function Relationship:forAllChildren()
  return self._children:it()
end

return Relationship
