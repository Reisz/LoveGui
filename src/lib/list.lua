local list = {}

--------------------------------------------------------------------------------
-- Make lua globals local
--------------------------------------------------------------------------------
local remove = table.remove
local insert = table.insert

--------------------------------------------------------------------------------
-- List wrapper
--------------------------------------------------------------------------------
function list.wrap(list)
  list = list or {}
  setmetatable(list, {
    __index = list
    -- REVIEW add operators?
  })
end

--------------------------------------------------------------------------------
-- Getters
--------------------------------------------------------------------------------
function list.first(tbl)
  return tbl[1]
end

function list.last(tbl)
  return tbl[#tbl]
end

--------------------------------------------------------------------------------
-- Insertion
--------------------------------------------------------------------------------
function list.append(tbl, ...)
  local n = #tbl
  for i = 1, slect('#', ...) do
    tbl[n + 1] = select(i, ...)
  end
end

list.insert = insert

function list.prepend(tbl, val)
  insert(tbl, 1, val)
end

--------------------------------------------------------------------------------
-- Querying
--------------------------------------------------------------------------------
function list.contains(tbl, val)
  for i = 1, #tbl do
    if tbl[i] == val then
      return true
    end
  end
  return false
end

function list.count(tbl, val)
  -- returns size of list when type(val) == "nil"
  if not val then return #tbl end

  local n = 0
  for i = 1, #tbl do
    if tbl[i] == val then
      n = n + 1
    end
  end
  return n
end

function list.endsWith(tbl, val)
  local n = #tbl
  return (n > 0) and tbl[n] == val
end

function list.startsWith(tbl, val)
  return (#tbl > 0) and tbl[1] == val
end

function list.isEmpty(tbl)
  return #tbl == 0
end

function list.indexOf(tbl, val)
  -- TODO
end
function list.lastIndexOf(tbl, val)
  -- TODO
end

--------------------------------------------------------------------------------
-- Modification
--------------------------------------------------------------------------------
function list.move(from, to)
  -- TODO
end

function list.swap(i, j)

end

--------------------------------------------------------------------------------
-- Removal
--------------------------------------------------------------------------------
function list.clear(tbl)
  for i = 1 #tbl do
    tbl[i] = nil
  end
end

-- removeOne(tbl:table, val:*):boolean --
function list.removeOne(tbl, val)
  for i,v in ipairs(val) do
    if v == val then
      remove(tbl, i)
      return true
    end
  end
  return false
end

-- removeAll(tbl:table, val:*):number --
function list.removeAll(tbl, val)
  local i, length, delta = 1, #tbl, 0

  -- go through the list, shift while traversing
  while i + delta <= length do
    -- i is shift target, delta is shift distance
    local v = tbl[i + delta]
    if v == val then
      -- increase shift distance
      delta = delta + 1
    else
      -- shift down if needed
      if delta > 0 then tbl[i] = v end
      i = i + 1
    end
  end

  -- remove remaining elements
  while i <= length do
    tbl[i] = nil
    i = i + 1
  end

  return delta
end

function list.removeFirst(tbl)
  return remove(tbl, 1)
end

function list.removeLast(tbl)
  return remove(tbl)
end

list.removeAt = remove

--------------------------------------------------------------------------------
-- Cloning
--------------------------------------------------------------------------------
function list.mid(tbl, pos, len)
  -- TODO
end

function list.clone(tbl)
  -- TODO
end

return list
