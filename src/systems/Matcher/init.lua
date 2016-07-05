local Matcher = {}

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

-- setup matcher code environment
local env = setmetatable({}, { __index = safeMethods })
Matcher.env = env
require "systems.Matcher.logic" (env)
require "systems.Matcher.type" (env)
require "systems.Matcher.lua" (env)

-- function Matcher.wrapCode(code:string) : function
local wrapCode
if _VERSION == "Lua 5.1" then
  wrapCode = function (code)
    local fn, msg = loadstring("return " .. code)
    if not fn then error(msg) end
    return setfenv(fn, env)()
  end
else -- Lua 5.2 or higher
  wrapCode = function (code)
    local fn, msg = load("return " .. code, "matcher", "bt", env)
    if not fn then error(msg) end
    return fn()
  end
end
Matcher.wrapCode = wrapCode

local function cleanCode(code)
  return string.gsub(code, "[%(%)]", {
    ["("] = "{", [")"] = "}"
  })
end


function Matcher.new(code)
  if code == "_" then return Matcher.all
  elseif code == "__" then return Matcher.none end

  local f = wrapCode(cleanCode(code))
  return setmetatable({}, {
    __call = function(_, ...) return f(...) end,
    __tostring = function() return code end
  })
end

Matcher.all = setmetatable({}, {
  __call = function() return true end,
  __tostring = function() return "all" end
})

Matcher.none = setmetatable({}, {
  __call = function() return false end,
  __tostring = function() return "none" end
})

return Matcher
