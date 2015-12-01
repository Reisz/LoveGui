local function typeMatcher(value, flags)
  if not flags then
    return type(value)
  elseif flags.any then
    return ""
  else
    local type = flags.type or type(value)
    local tFlags = getmetatable(type)

    if flags.ignoreNil then tFlags.ignoreNil = true end

    return type
  end
end

-- return true if type _t matches expected type t
local function check(t, _t)
  if _t == "nil" and getmetatable(t).ignoreNil then
    return true
  end
  return t == "" or t == _t
end

return function()
  return typeMatcher, check
end
