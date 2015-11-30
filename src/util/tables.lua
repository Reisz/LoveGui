local tables = {}

function tables.shallowCopy(tbl)
  return setmetatable({}, { __index = tbl })
end

function tables.deepCopy(tbl)
  local result = {}
  for i, v in pairs(tbl) do
    result[i] = v
  end
  return result
end

return tables
