local list = {}

--------------------------------------------------------------------------------
-- Localize table functions
--------------------------------------------------------------------------------
local remove = table.remove

--------------------------------------------------------------------------------
-- Removal
--------------------------------------------------------------------------------
-- removeOne(tbl:table, val:*):boolean --
function list:removeOne(tbl, val)
  for i,v in ipairs(val) do
    if v == val then
      remove(tbl, i)
      return true
    end
  end
  return false
end

-- removeAll(tbl:table, val:*):number --
function list:removeAll(tbl, val)
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

return list
