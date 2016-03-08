local Set = require "util.set"

local Event = {}

local objects = setmetatable({}, {__mode = "k"})
Event.objects = objects

-- ObjectData: contains map<String(eventName), HandlerMap>
local function createObjectData(object)
  local data = {}; objects[object] = data; return data
end

local function getObjectData(object)
  return objects[object] or createObjectData(object)
end; Event.getObjectData = getObjectData

-- HandlerMap: contains map<String(selector), HandlerSet>
local function createHandlerMap(objectData, event)
  local map = {}; objectData[event] = map; return map
end

local function getHandlerMap(object, event)
  local objectData = getObjectData(object)
  return objectData[event] or createHandlerMap(objectData, event)
end; Event.getHandlerMap = getHandlerMap

-- HandlerSet: contains set<Handler>
local function createHandlerSet(handlerMap, selector)
  local set = Set(); handlerMap[selector] = set; return set
end

local function getHandlerSet(object, event, selector)
  local handlerMap = getHandlerMap(object, event)
  return handlerMap[selector] or createHandlerSet(handlerMap, selector)
end; Event.getHandlerSet = getHandlerSet


local function addHandler(object, event, selector, data, handler)
  getHandlerSet(object, event, selector):insert{handler, data}
end; Event.addHandler = addHandler

local function filter(v, handler) return v[1] == handler end
local function removeHandler(object, event, selector, handler)
  if not handler then -- removeEveryHandler for this event/selector
    getHandlerMap(object, event)[selector] = nil
  else -- remove specific types of handlers from this event/selector
    getHandlerSet(object, event, selector):removeFilter(filter, handler)
  end
end; Event.removeHandler = removeHandler

-- TODO
-- luacheck: no unused
local function triggerHandler(object, event, selector, eventObject, ...)
  getHandlerSet(object, event, selector)
end

Event.mixin = {}
local function args_on(p1,p2,p3)
  if p3 then
    return p1 or "", p2, p3
  elseif p2 and type(p1) == "string" then
    return p1 or "", nil, p2
  elseif p2 then
    return "", p1, p2
  end

  return "", nil, p1
end

local function args_off(p1, p2)
  if p2 then
    return p1 or "", p2
  elseif type(p1) == "string" then
    return p1 or ""
  end

  return "", p1
end

-- :on(events:string, [selector:string], [data:table], handler:callable)
function Event.mixin:on(events, p1, p2, p3)
  local selector, data, handler = args_on(p1,p2,p3)
  for event in string.gmatch(events, "[^ ]+") do
    addHandler(self, event, selector, data, handler)
  end
end

-- :one(events:string, [selector:string], [data:table], handler:callable)
function Event.mixin:one(events, p1, p2, p3)
  local selector, data, handler = args_on(p1,p2,p3)
  for event in string.gmatch(events, "[^ ]+") do
    local onceFn; onceFn = function(e, ...)
      e.data = data; handler(e, ...)
      removeHandler(self, event, selector, onceFn)
    end
    addHandler(self, event, selector, nil, onceFn)
  end
end

-- :off(events:string, [selector:string], [handler:string])
function Event.mixin:off(events, p1, p2)
  local selector, handler = args_off(p1,p2)
  for event in string.gmatch(events, "[^ ]+") do
    removeHandler(self, event, selector, handler)
  end
end

function Event.mixin:trigger(event, ...)
  triggerHandler(self, event, self.class.name, ...)
end
