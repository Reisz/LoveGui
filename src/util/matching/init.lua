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

local function matcher(s)
  if _VERSION == "Lua 5.1" then
    local chunk = loadstring("return " .. s)
    return setfenv(chunk, env)()
  else -- Lua 5.2 or higher
    return load("return " .. s, "matcher", "bt", env)()
  end
end

return matcher
