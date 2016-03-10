local class = require "lib.middleclass"
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

-- this will not run the event in the same cycle
local function addHandler(object, event, handler)
  local handlerList = getHandlerList(object, event) or newHandlerList(object, event)
  handlerList[#handlerList + 1] = handler
end; Event.static.addHandler = addHandler

local function removeAll(object, event)
  local objectData = getObjectData(object)
  local handlerList = objectData[event]
  -- make sure to stop immediate propagation
  if handlerList and handlerList.lock then
    handlerList.deleteAll = true
  elseif objectData then
    objectData[event] = nil
  end
end; Event.removeAll = removeAll

local function find(list, v) for i = 1, #list do if list[i] == v then return i end end end
local function removeHandler(object, event, handler)
  local handlerList = getHandlerList(object, event)
  if handlerList then
    if handlerList.lock then
      -- set the value to nil
      for i = 1, handlerList.count do
        if handlerList[i] == handler then
          handlerList[i], handlerList.deleted = nil, true
          return
        end
      end
    else -- not locked
      local i = find(handlerList, handler)
      if i then remove(handlerList, i) end
      if #handlerList == 0 then removeAll(object, event) end
    end
  end
end; Event.static.removeHandler = removeHandler

local function removeByFunction(object, event, fun)
  local handlerList = getHandlerList(object, event)
  if handlerList then
    if handlerList.lock then
      -- set the value to nil
      for i = 1, handlerList.count do
        local h = handlerList[i]
        if h and h[1] == fun then
          handlerList[i], handlerList.deleted = nil, true
        end
      end
    else -- not locked
      local newList, index = newHandlerList(object, event), 1
      for i = 1, #handlerList do
        local h = handlerList[i]
        if h[1] ~= fun then
          newList[index], index = h,  index + 1
        end
      end
      if #newList == 0 then removeAll(object, event) end
    end
  end
end; Event.static.removeByFunction = removeByFunction

local function triggerEvent(object, event, eventObject, ...)
  local handlerList = getHandlerList(object, event)
  local stop = false
  if handlerList then
    -- when lock is set, keep index order intact when deleting
    handlerList.lock = true -- not a concurrency lock
    local count = #handlerList; handlerList.count = count -- for deleting
    for i = 1, count do
      local handler = handlerList[i]
      -- handler could be deleted while going through the list
      if handler then
        eventObject.data = handler[2]
        if handler[1](eventObject, ...) == false then stop = true end
        if eventObject.stopImmediate or handlerList.deleteAll then break end
      end
    end
    -- lock can be unset now, because unwanted modification will
    -- only happen when executing handlers
    handlerList.lock, handlerList.count = nil, nil

    -- remove every handler
    if handlerList.deleteAll then
      newHandlerList(object, event)
    elseif handlerList.deleted then -- or fix list ordering
      local newList, index = newHandlerList(object, event), 1
      for i = 1, count do -- old count will still be accurate
        local h = handlerList[i]
        if h then newList[index], index = h, index + 1 end
      end
      if index == 1 then removeAll(object, event) end
    end
  end

  if stop or eventObject.stop or eventObject.stopImmediate then return end

  local parent = object.parent
  if parent then return triggerEvent(parent, event, eventObject, ...) end
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
    local handler, onceFun; onceFun = function(e, ...)
      local result = fun(e, ...); removeHandler(self, event, handler); return result
    end; handler = newHandler(onceFun, data)
    addHandler(self, event, handler)
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
