local metatables = require "util.matching.metatables"
local class = require "lib.middleclass"
local Object = class.Object

local env = { is = {} }

local function usemt_call(name)
  local mt = metatables[name]
  local function call(_, ...) return setmetatable({...}, mt) end
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

local function usemt_map(name)
  local mt = metatables[name]
  env[name] = function(tbl)
    local result = {}
    for i = 1, #tbl do result[tbl[i]] = true end
    return setmetatable(result, mt)
  end
end

-- utility matchers
env["_"] = function() return true end
env["__"] = function() return false end
usemt_list "all"
usemt_list "any"
usemt_call "may"

-- lua matchers
env.t = require "util.matching.type"
usemt_map "v" -- set of possible values
usemt_list "tbl" -- structure of a table
usemt_call "list" -- (matcher, min, max) (min & max == nil -> any length, also empty) (max == nil -> exact size)
usemt_call_index "pt" -- string matches a pattern
usemt_call_index "ts" -- tostring equals
usemt_call_index "ts_pt" -- tostring matches a pattern
usemt_call_index "tn" -- tonumber equals
-- functions work implicitly, because global environment is set

-- middleclass matchers
function env.is.class(v) return Object.isSubclassOf(v, Object) end
function env.is.object(v) return Object.isInstanceOf(v, Object) end
usemt_call_index "c" -- class name equals
usemt_call_index "c_pt" -- class name matches a pattern
usemt_call_index "o" -- object of class with name equals
usemt_call_index "o_pt" -- object of class with name matches a pattern
usemt_call_index "subc" -- subclass of class with name equals
usemt_call_index "subc_pt" -- subclass of class with name matches a pattern

-- love2d matchers
function env.is.l2object(v) return type(v) == "userdata" and type(v.typeOf) == "function" end
usemt_call_index "l2t" -- is love2d object with type equals

-- setup lua globals
local safeMethods = {}
for v in string.gmatch([[
  string table utf8 math
  getmetatable ipairs next pairs
  rawequal rawget rawlen
  tonumber tostring type
]], "%S+") do
  safeMethods[v] = _G[v]
end

return setmetatable(env, { __index = safeMethods })
