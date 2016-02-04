local set = {}

function set.new(...)
  local s = {}
  for i = 1, select("#", ...) do
   set.insert(s, select(i, ...))
  end
  return setmetatable(s, { __index = set })
end

function set:insert(v) self[v] = true end
function set:remove(v) self[v] = nil end

function set:contains(v)
  return self[v] or false
end

function set:intersect(other)
  for v in set.it(self) do
    if other[v] ~= true then
      self[v] = nil
    end
  end
end

function set:union(other)
  for v in set.it(other) do
    self[v] = true
  end
end

function set:it() return pairs(self) end

function set:toList()
  local list, i = {}, 1
  for v in set.it(self) do
    list[i], i = v, i + 1
  end
  return list
end

function set:copy()
  local result = getmetatable(self).__index == set and set.new() or {}
  for v in set.it(self) do
    set.insert(result, v)
  end
  return result
end

return set
