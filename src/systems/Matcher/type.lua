local function addType(env, name)
  env[name] = function(value)
    return type(value) == name
  end
end

return function(env)
  addType(env, "number")
  addType(env, "string")
  addType(env, "boolean")
  addType(env, "table")
  addType(env, "function")
  addType(env, "thread")
  addType(env, "userdata")
end
