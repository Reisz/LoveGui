--- # Type Matching
--- To ensure easy identification of errors, every property will, when its
--- value is changed, verify, if the new value matches a certain set of
--- conditions. When the conditions are not met, an error is thrown ideally
--- including line markings, pointing at the component initialization.
---
--- This api will provide two functions: `typeMatcher(value, flags)` returns a
--- string with some additional data set in its metatable.
--- `check(matcher, value)`, will return true, when the value fullfills the
--- conditions of the given matcher, false otherwise. For convenience the
--- __call field of the matchers metatable is set to check, allowing you to
--- write `matcher(value)`.

local env = require "util.matching.env"

local matcher = {}

function matcher.getFunction(m)
  if _VERSION == "Lua 5.1" then
    local fn, msg = loadstring("return " .. m)
    if not fn then error(msg) end
    return setfenv(fn, env)()
  else -- Lua 5.2 or higher
    local fn, msg = load("return " .. m, "matcher", "bt", env)
    if not fn then error(msg) end
    return fn()
  end
end

local matcherId = {}
function matcher.create(m)
  local _m, mt = matcher.getFunction(m)
  if type(_m) == "table" then
    mt = getmetatable(_m)
  else
    mt = { __call = _m }
    _m = setmetatable({}, mt)
  end
  mt.__tostring = function() return m end
  mt[matcherId] = true
  return _m
end

function matcher.isMatcher(m)
  return m and (getmetatable(m) or matcherId)[matcherId]
end

return setmetatable(matcher, { __call = function(_, ...) return matcher.create(...) end })
