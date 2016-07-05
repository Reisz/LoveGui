local set = {}

function set.initialize()
  local s = { _add = {}, _rem = {} }
  return setmetatable(s, { __index = set })
end

function set:clone()
  local s = set.initialize()
  s._parent = self
  setmetatable(s._add, { __index = self._add })
  setmetatable(s._rem, { __index = self._rem })
  return s
end

function set:setMatcher(m)
  self.matcher = m
end

function set:getMatcher()
  return self.matcher
end

function set:add(...)
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    if self.matcher then assert(self.matcher(v)) end
    -- double adding here is ok (explicit add)
    self._add[v] = true
    self._rem[v] = false
  end
end

function set:rem(...)
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    self._add[v] = nil
    self._rem[v] = true
  end
end; set.remove = set.rem

function set:has(v)
  return (not self._rem[v]) and (self._add[v] or false)
end

local function set_next(sets, key)
  local s = sets[#sets]
  local k = next(s._add, key)

  if k and (not sets[1]._rem[k]) and (not sets.traversed[k]) then
    sets.traversed[k] = true
    return k
  end
  if type(k) == "nil" then
    table.remove(sets)
    if #sets == 0 then return nil end
  end

  return set_next(sets, k)
end

function set:it()
  local sets = {self, traversed = {}}
  local p = self._parent
  while p do
    table.insert(sets, p)
    p = p._parent
  end
  return set_next, sets, nil
end

return set
