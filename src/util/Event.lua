local class = require "util.middleclass"
local remove = table.remove

local Event = class("Event")



local objects = setmetatable({}, {__mode = "k"})
Event.static.objects = objects

local function getObjectData(object)
  return objects[object]
end; Event.static.getObjectData = getObjectData

local function newObjectData(object)
  local data = {}; objects[object] = data; return data
end; Event.static.newObjectData = newObjectData

local function getHandlerList(object, event)
  local objectData = getObjectData(object)
  return objectData and objectData[event]
end Event.static.getHandlerList = getHandlerList

local function newHandlerList(object, event)
  local objectData = getObjectData(object) or newObjectData(object)
  local list = {}; objectData[event] = list; return list
end Event.static.newHandlerList = newHandlerList

local function newHandler(fun, data)
  return {fun, data}
end; Event.static.newHandler = newHandler

local function addHandler(object, event, handler)
  local handlerList = getHandlerList(object, event) or newHandlerList(object, event)
  local index = #handlerList + 1; handlerList[index] = handler; return index
end; Event.static.addHandler = addHandler

local function removeHandler(object, event, index)
  local handlerList = getHandlerList(object, event)
  if handlerList then remove(handlerList, index) end
end; Event.static.removeHandler = removeHandler

local function removeByFunction(object, event, fun)
  local oldHandlerList = getHandlerList(object, event)
  if oldHandlerList then
    local handlerList, index = newHandlerList(object, event), 1
    for i = 1, #oldHandlerList do
      local oldHd = oldHandlerList[i]
      if oldHd[1] ~= fun then
        handlerList[index] = oldHd
        index = index + 1
      end
    end
  end
end; Event.static.removeByFunction = removeByFunction

local function removeAll(object, event)
  local objectData = getObjectData(object)
  if objectData then objectData[event] = nil end
end; Event.removeAll = removeAll

local function triggerEvent(object, event, eventObject, ...)
  local handlerList = getHandlerList(object, event)
  for i = 1, # handlerList do
    local handler = handlerList[i]
    eventObject.data = handler[2]
    handler[1](eventObject, ...)
    if event.stopImmediate then return end
  end

  if event.stop then return end

  local parent = object.parent
  if parent then return triggerEvent(parent, eventObject, ...) end
end; Event.static.triggerEvent = triggerEvent



Event.static.mixin = {}

local gmatch = string.gmatch
local function it_events(events) return gmatch(events, "[^ ]+") end

local function dummy() return false end
Event.static.falseDummy = dummy

-- :on(events:string, [data:table], fun:callable|<false>)
function Event.static.mixin:on(events, data, fun)
  if type(fun) == "nil" then fun = data; data = nil end
  if fun == false then fun = dummy end
  for event in it_events(events) do
    addHandler(self, event, newHandler(fun, data))
  end
end

-- :one(events:string, [data:table], fun:callable|false)
function Event.static.mixin:one(events,  data, fun)
  if type(fun) == "nil" then fun = data; data = nil end
  if fun == false then fun = dummy end
  for event in it_events(events) do
    local index, onceFun; onceFun = function(e, ...)
      e.data = data; fun(e, ...)
      removeHandler(self, event, index)
    end
    index = addHandler(self, event, newHandler(onceFun, nil))
  end
end

-- :off(events:string, [fun:callable|false])
function Event.static.mixin:off(events, fun)
  if type(fun) == "nil" then
    for event in it_events(events) do removeAll(self, event) end
  else
    if fun == false then fun = dummy end
    for event in it_events(events) do
      removeByFunction(self, event, fun)
    end
  end
end

-- :tigger(event:string, ...)
function Event.static.mixin:trigger(event, ...)
  local eventObject = Event(event, self)
  triggerEvent(self, event, eventObject, ...)
end



function Event:initialize(type, target)
  self.type, self.target = type, target
  self.stop, self.stopImmediate = false, false
end

function Event:stopPropagation() self.stop = true end
function Event:stopImmediatePropagation() self.stopImmediate = true end

function Event:getTarget() return self.target end
function Event:getData() return self.data end

return Event
