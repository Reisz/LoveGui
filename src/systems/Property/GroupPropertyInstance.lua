local GroupPropertyInstance = {}

function GroupPropertyInstance:get()
  return self
end

local function fn_set(self, value, method)
  assert(type(value) == "table")
  for i, v in pairs(value) do
    local p = self[i]
    if p then p[method](v)
    else print("Unknown subproperty: " .. i) end
  end
end

function GroupPropertyInstance:set(value)
  fn_set(self, value, "set")
end

function GroupPropertyInstance:set(value)
  fn_set(self, value, "set")
end

return { __index = GroupPropertyInstance }
