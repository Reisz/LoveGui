local binding = {}
function binding:notify(value)
  local cb = self.callbacks
  for i = 1, #cb do cb[i](value) end
end

function binding:bind(fn)
  table.insert(self.callbacks, fn)
  return function() fn(self:get()) end
end

function binding:bindTo(tbl, key)
  return self:bind(function(val) tbl[key] = val end)
end

return function(tbl)
  for i, v in pairs(binding) do
    tbl[i] = v
  end
end
