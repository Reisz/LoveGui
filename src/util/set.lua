local Set = {}

function Set.new(...)
  local s = {}
  for i = 1, select("#", ...) do
   Set.insert(s, select(i, ...))
  end
  return setmetatable(s, { __index = Set })
end

function Set:insert(v) self[v] = true end
function Set:remove(v) self[v] = nil end

function Set:contains(v)
  return self[v] or false
end

function Set:intersect(other)
  for v in Set.it(self) do
    if other[v] ~= true then
      self[v] = nil
    end
  end
  return self
end

function Set:union(other)
  for v in Set.it(other) do
    self[v] = true
  end
  return self
end

function Set:it() return pairs(self) end

function Set:filterRemove(fn, ...)
  for v in Set.it(self) do
    if fn(v, ...) then
      self[v] = nil
    end
  end
end

function Set:toList()
  local list, i = {}, 1
  for v in Set.it(self) do
    list[i], i = v, i + 1
  end
  return list
end

function Set:copy()
  local result = getmetatable(self).__index == Set and Set.new() or {}
  for v in Set.it(self) do
    Set.insert(result, v)
  end
  return result
end

return Set
