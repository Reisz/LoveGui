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
---
--- ## Matching Functionality
--- This api supports the follwing functianlities when mathing type
---
--- ### Matching anything
--- This matcher will be used when the flag `any` is set. It will override any
--- other flags and match everything including nil.
---
--- ### Matching to lua `type()`
--- This is the default mode that will be applied, when no flags are set.
--- The matcher will be the string value returned by type(value) and matching
--- will be done to type(newValue). This will not match nil, unless the original
--- value was nil. Set `flags.type` manually, when the default value doesn't
--- achieve the necessary result (especially for more complicated matchers).
---
--- ### Include nil
--- Setting the `ignoreNil` flag, will match nil **and** every other value, the
--- matcher allows for. This will evaluated after the `any` flag, in case the
--- new value is nil.
---
--- ### Matching values
--- Setting `flags.values` to a table, containing a list of all allowed values
--- will only match, if the newValue is exactly equal to the specified (custom
--- __eq will not work). This also means, that `flags.values` is not useful for
--- table values. It is mostly supposed to be used for a enumeration property
--- allowing for multiple different strings.
---
--- ### Submatchers
--- If `flags.anyOf` or `flags.allOf` are set to a list of sets of flags.
--- Matchers will be created for every set of flags. When a new value is being
--- checked, matchers will be evaluated, until the result of the boolean
--- operation is unchangeable or the last matcher was evaluated.
--- #### Example:
--- ```lua
--- flags = {
---   anyOf = {
---     {values = {"red", "blue", "green"}},
---     {tableContent = {"number", "number", "number"}}
---   }
--- }

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
