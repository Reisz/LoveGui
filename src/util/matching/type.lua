-- using actual table to prevent errors
local types = {}

local function addType(name)
  types[name] = function(v)
    return type(v) == name
  end
end

addType "number"
addType "string"
addType "boolean"
addType "table"
addType "function"
addType "thread"
addType "userdata"

return types
