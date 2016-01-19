local result = {}

local tbl = {}
function result:get(k)
  return (self[1] or tbl)[k]
end

function result:getResult(k, ...)
  local fn = self:get(k)
  if type(fn) == "function" then return fn(...) end
end

function result:set(k, v)
  for i = 1, #self do
    self[i][k] = v
  end
end

function result:call(k, ...)
  for i = 1, #self do
    self[i][k](...)
  end
end

return { __index = result }
