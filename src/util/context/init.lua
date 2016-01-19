local resultTbl = require "util.context.result"

local context = {}

function context:register(element, id, class)
  if not id then return end
  self.id[id] = element
  for v in string.gmatch(class or "", "[^ ]+") do
    self:addClass(element, v)
  end
end

function context:addClass(element, class)
  if not self.class[class] then self.class[class] = {} end
  table.insert(self.class[class], element)
end

function context:query(q)
  local result = {}
  for u in string.gmatch(q, "[^,]+") do
    local sign, name = string.match(u, "^(%.?)(.*)$")
    if sign == "." then
      local t = self.class[name]
      if t then
        for _,v in ipairs(t) do
          table.insert(result, v)
        end
      end
    else
      table.insert(result, self.id[name])
    end
  end
  return setmetatable(result, resultTbl)
end

function context:activate() context.setCurrent(self) end

-- static functions
local mt =  { __index = context, __call = context.query }
function context.create()
  local ctx = { id = {}, class = {} }
  return setmetatable(ctx, mt)
end

function context.setCurrent(ctx)
  package.loaded["util.context"] = ctx
end

return context.create()
