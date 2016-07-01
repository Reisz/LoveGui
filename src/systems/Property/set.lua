local set = {}

function set.initialize()
  local s = { _add = {}, _rem = {} }
  return setmetatable(s, { __index = set })
end

function set:clone(other)
  local s = set.initialize()
  setmetatable(s._add, { __index = function(_, key)
    return other:has(key)
  end })
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
    self._rem[v] = nil
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
  return (not self.rem[v]) and self.add[v]
end

function set:it()
  -- TODO
end

return set
