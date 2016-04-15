local set = require "util.set"

local result, empty = {}, {}

-- STATIC
function result:clear()
  return setmetatable({context = self.context, set = {}}, { __index = result })
end

-- ATTRIBUTE MANIPULATION
function result:get(k)
  return (select(2, next(self.set)) or empty)[k]
end

function result:getResult(k, ...)
  local fn = self.set:get(k)
  if type(fn) == "function" then return fn(...) end
end

function result:set(k, v)
  for element in set.it(self.set) do
    element[k] = v
  end

  return self
end

function result:call(k, ...)
  for element in set.it(self.set) do
    element[k](...)
  end

  return self
end

-- ITERATING
function result:each(fn)
  for element in set.it(self.set) do
    fn(element)
  end

  return self
end

function result:map(fn)
  local mapped = self:clear()
  for element in set.it(self.set) do
    set.insert(mapped.set, fn(element))
  end

  return mapped
end

-- RESULT MAIPULTAION
function result:keep(filter)
  local fn, filtered = self.context.createFilter(filter), self:clear()
  for element in set.it(self.set) do
    if fn(element) then set.insert(filtered.set, element) end
  end

  return filtered
end

function result:remove(filter)
  local fn, filtered = self.context.createFilter(filter), self:clear()
  for element in set.it(self.set) do
    if not fn(element) then set.insert(filtered.set, element) end
  end

  return filtered
end

function result:find(filter)
  local fn, filtered = self.context.createFilter(filter), self:clear()
  for element in set.it(self.set) do
    if fn(element) then
      set.insert(filtered.set, element)
      return filtered
    end
  end

  return filtered
end

function result:add(elements)
  local merged = setmetatable(set.copy(self.set), { __index = result })
  if type(elements) ~= "table" then
    set.union(merged.set, self.context.query(elements).set)
  elseif getmetatable(elements).__index ~= result then
    set.insert(merged.set, elements)
  else
    if elements.context == self.context then
      set.union(merged.set, elements.set)
    end
  end

  return merged
end

-- CLASS MANIPULATION
local function classRotation(self, class, fn, ...)
  local classes, len = {}, 0
  for cl in string.gmatch(class, "[^ ]+") do
    len = len + 1
    classes[len] = cl
  end
  if len <= 0 then return self end

  local ctx = self.context
  for v in set.it(self.set) do
    for i = 1, len do
      fn(ctx, v, classes[i], ...)
    end
  end
  return self
end

local function directCall(ctx, v, class, fn) fn(ctx, v, class) end
function result:addClass(class)
  return classRotation(self, class, directCall, self.context.addClass)
end
function result:removeClass(class)
  return classRotation(self, class, directCall, self.context.removeClass)
end

local function toggleCall(ctx, v, class, add, remove, has)
  if has(ctx, v, class) then remove(ctx, v, class)
  else add(ctx,v, class) end
end
function result:toggleClass(class, state)
  if state then
    return classRotation(self, class, directCall, self.context.addClass)
  elseif type(state) == "boolean" then
    return classRotation(self, class, directCall, self.context.removeClass)
  else
    return classRotation(self, class, toggleCall, self.context.addClass,
      self.context.removeClass, self.context.hasClass)
  end
end

function result:hasClass(class)
  local ctx, has = self.context, self.context.hasClass
  for v in set.it(self.set) do
    if has(ctx, v, class) then return true end
  end

  return false
end

return result
