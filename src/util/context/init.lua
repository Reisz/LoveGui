local set = require "util.set"

local result = require "util.context.result"

-- BEGIN matcher loading safety
local matcher
if pcall(require, "util.matching") then
  matcher = package.loaded["util.matching"]
elseif _VERSION == "Lua 5.1" then
  matcher = function(m)
    local fn, msg = loadstring("return " .. m)
    if not fn then error(msg) end
    return fn()
  end
else -- Lua 5.2 or higher
  matcher = function(m)
    local fn, msg = load("return " .. m, "matcher", "bt")
    if not fn then error(msg) end
    return fn()
  end
end
-- END matcher loading safety


--- %module util
--- %class context
--- Context is used...

local context, empty, current = {}, {}

--- %function
--- @param element
function context:register(element, id, class)
  if id then self.id[id] = element end
  for c in string.gmatch(class or "", "[^ ]+") do
    self:addClass(element, c)
  end
end

local function getClass(tbl, class)
  local v = tbl[class]; if v then return v end
  v = setmetatable({}, {__mode = "v"}); tbl[class] = v
  return v
end

function context:addClass(element, class)
  set.insert(getClass(self.class, class), element)
end

function context:removeClass(element, class)
  set.remove(getClass(self.class, class), element)
end

function context:hasClass(element, class)
  return set.contains(getClass(self.class, class), element)
end

local function dummy() return true end
function context.createFilter(filter)
  local t = type(filter)
  if t == "nil" then return dummy
  elseif t == "function" then return filter end
  return matcher(filter)
end


local pattern = "^(%.?)([^ :]*):(.*)$"
local function subquery(resultSet, q)
  local sign, name, filter = string.match(q, pattern)
  filter = context.createFilter(filter)

  if sign == "." then
    local t = self.class[name]
    for v in set.it(t or empty) do
      if filter(v) then set.insert(resultSet, v) end
    end
  else
    local v = self.id[name]
    if filter(v) then set.insert(resultSet, v) end
  end
end

function context:query(q)
  local resultSet = {}
  for u in string.gmatch(q, "[^,]+") do
    subquery(resultSet, u)
  end
  return setmetatable({ context = self, set = resultSet }, { __index = result })
end

function context:activate()
  context.setCurrent(self)
  return self
end

-- static functions
local mt =  { __index = context, __call = context.query }
function context.create()
  local ctx = {id = setmetatable({}, {__mode = "v"}), class = {} }
  return setmetatable(ctx, mt)
end

function context.setCurrent(ctx) current = ctx end
return function() return current or context.create:activate() end
