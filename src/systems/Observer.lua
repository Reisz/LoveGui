local Observer = {}
local dummy_list = {}

--------------------------------------------------------------------------------
-- Global Methods
--------------------------------------------------------------------------------
local objects = setmetatable({}, { __mode = "k" })
Observer.objects = objects

local function newNameList(tbl, object)
  local list = {}; tbl[object] = list; return list
end
local function newReceiverList(tbl, name)
  -- observers should still be able to be gc'd
  local list = setmetatable({}, { __mode = "k" })
  tbl[name] = list; return list
end
local function newHandlerEntry(tbl, receiver, hnd_name)
  tbl[receiver] = hnd_name
end

local function getNameList(object, create)
  return (objects and objects[object])
    or (create and newNameList(objects, object))
end; Observer.getNameList = getNameList

local function getReceiverList(object, name, create)
  local nameList = getNameList(object, create)
  return (nameList and nameList[name])
    or (create and newReceiverList(nameList, name))
end; Observer.getReceiverList = getReceiverList

function Observer.subscribeTo(sender, msg_name, receiver, hnd_name)
  newHandlerEntry(getReceiverList(sender, msg_name, true), receiver, hnd_name)
end

function Observer.unsubscribeFrom(sender, msg_name, receiver, hnd_name)
  local list = getReceiverList(sender, msg_name)
  for i,v in pairs(list or dummy_list) do
    if i == receiver and (hnd_name and v == hnd_name) then
      list[i] = nil
    end
  end
end

function Observer.notifyAs(sender, msg_name, ...)
  local list = getReceiverList(sender, msg_name)
  for i,v in pairs(list or dummy_list) do
    i[v](sender, msg_name, ...)
  end
end

--------------------------------------------------------------------------------
-- Instance Methods
--------------------------------------------------------------------------------
Observer.mixin = {}
Observer.mixin.subscribe = Observer.subscribeTo
Observer.mixin.unsubscribe = Observer.unsubscribeFrom
Observer.mixin.notify = Observer.notifyAs

return Observer
