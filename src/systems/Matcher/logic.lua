local functions = {
  all = function (self, ...)
    for i = 1, #self do
      if not self[i] then return false end
    end
  end,

  any = function(self, ...)
    for i = 1, #self do
      if self[i](...) then return true end
    end
    return false
  end,

  may = function(self, value)
    if type(value) == "nil" then return true end
    return self[1](value)
  end
}

return function (env)
  env["_"] = function() return true end
  env["__"] = function() return false end

  for i,v in pairs(functions) do
    env[i] = function(tbl)
      return setmetatable(tbl, { __call = v })
    end
  end
end
