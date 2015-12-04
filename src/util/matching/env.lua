local metatables = require "util.matching.metatables"
local class = require "util.middleclass"
local Object = class.Object

local env = { is = {} }

local function usemt_call_index(name)
  local mt = metatables[name]
  local function call_index(self, value) return setmetatable({value}, mt) end
  env[name] = setmetatable({}, { __call = call_index, __index = call_index })
end

local function usemt_list(name)
  local mt = metatables[name]
  env[name] = function(tbl)
    return setmetatable(tbl, mt)
  end
end

-- utility matchers
env["_"] = function() return true end
usemt_list "all"
usemt_list "any"

-- lua matchers
env.t = require "util.matching.type"
usemt_list "v"
usemt_list "tbl"
usemt_call_index "ts"
usemt_call_index "tn"
-- TODO figure out syntax for functions

-- middleclass matchers
function env.is.class(v) return Object.inSubclassOf(v, Object) end
function env.is.object(v) return Object.isInstanceOf(v, Object) end
usemt_call_index "c"
usemt_call_index "o"
usemt_call_index "subC"
usemt_call_index "supC"

return env
