local metatables = require "util.matching.metatables"
local class = require "util.middleclass"
local Object = class.Object

local env = { is = {} }

local function usemt_call(name)
  local mt = metatables[name]
  local function call(_, value) return setmetatable({value}, mt) end
  env[name] = setmetatable({}, { __call = call })
end

local function usemt_call_index(name)
  local mt = metatables[name]
  local function call_index(_, value) return setmetatable({value}, mt) end
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
usemt_call "may"

-- lua matchers
env.t = require "util.matching.type"
usemt_list "v" -- set of possible values
usemt_list "tbl" -- structure of a table
usemt_call_index "pt" -- string matches a pattern
usemt_call_index "ts_pt" -- tostring matches a pattern
usemt_call_index "ts" -- tostring equals
usemt_call_index "tn" -- tonumber equals
-- functions work implicitly, when global environment is set

-- middleclass matchers
function env.is.class(v) return Object.inSubclassOf(v, Object) end
function env.is.object(v) return Object.isInstanceOf(v, Object) end
usemt_call_index "c" -- class name equals
usemt_call_index "c_pt" -- class name matches a pattern
usemt_call_index "o" -- object of class with name equals
usemt_call_index "o_pt" -- object of class with name matches a pattern
usemt_call_index "subc" -- subclass of class with name equals
usemt_call_index "subc_pt" -- subclass of class with name matches a pattern


-- love2d matchers
usemt_call_index "l2t" -- is love2d object with type equals

return setmetatable(env, { __index = _G })
