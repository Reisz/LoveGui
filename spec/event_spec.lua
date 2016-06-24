local class = require "lib.middleclass"
local Event = require "systems.Event"

local Object = class("Object")
function Object:initialize(parent) self.parent = parent end
Object:include(Event.mixin)

describe("util.Event", function()
  local parent, child_a, child_b, child_a_a

  setup(function()
    parent = Object()
    child_a, child_b = Object(parent), Object(parent)
    child_a_a = Object(child_a)
  end)

  before_each(function()
    for i in pairs(Event.objects) do Event.objects[i] = nil end
  end)

  it("should be able to add a handler to an event", function()
    local handler = Event.newHandler("handler")
    Event.addHandler(parent, "test", handler)
    assert.are.equal(handler, Event.objects[parent].test[1])
  end)

  it("should be able to add multiple handlers to an event", function()
    local handlerA, handlerB = Event.newHandler("handlerA"), Event.newHandler("handlerB")
    Event.addHandler(parent, "test", handlerA)
    Event.addHandler(parent, "test", handlerB)
    assert.are.equal(handlerA, Event.objects[parent].test[1])
    assert.are.equal(handlerB, Event.objects[parent].test[2])
  end)

  it("should be able to remove handlers by reference", function()
    local handlerA, handlerB, handlerC = Event.newHandler("handlerA"), Event.newHandler("handlerB"), Event.newHandler("handlerC")
    Event.addHandler(parent, "test", handlerA)
    Event.addHandler(parent, "test", handlerB)
    Event.addHandler(parent, "test", handlerC)
    Event.removeHandler(parent, "test", handlerB)
    assert.are.equal(handlerA, Event.objects[parent].test[1])
    assert.are.equal(handlerC, Event.objects[parent].test[2])
  end)

  it("should be able to remove handlers by function", function()
    local function f1() end; local function f2() end
    local handlerA, handlerB, handlerC = Event.newHandler(f1), Event.newHandler(f2), Event.newHandler(f1)
    Event.addHandler(parent, "test", handlerA)
    Event.addHandler(parent, "test", handlerB)
    Event.addHandler(parent, "test", handlerC)
    Event.removeByFunction(parent, "test", f1)
    assert.are.same({handlerB}, Event.objects[parent].test)
  end)

  it("should be able to remove all handlers", function()
    local handlerA, handlerB = Event.newHandler("handlerA"), Event.newHandler("handlerB")
    Event.addHandler(parent, "test", handlerA)
    Event.addHandler(parent, "test", handlerB)
    Event.removeAll(parent, "test")
    assert.is_nil(Event.objects[parent].test)
  end)

  it("should be able to trigger events", function()
    local s = spy.new(function() end)
    Event.addHandler(parent, "test", Event.newHandler(function(_, ...) s(...) end))
    Event.triggerEvent(parent, "test", Event("test", parent), 5, 10)
    assert.spy(s).was_called(1)
    assert.spy(s).was_called_with(5, 10)
  end)

  it("should call all attached handlers", function()
    local s1, s2 = spy.new(function() end), spy.new(function() end)
    local handler1, handler2, eventObject = Event.newHandler(s1), Event.newHandler(s2), Event("test", parent)
    Event.addHandler(parent, "test", handler1)
    Event.addHandler(parent, "test", handler2)
    Event.triggerEvent(parent, "test", eventObject, 5, 10)
    assert.spy(s1).was_called(1)
    assert.spy(s2).was_called(1)
  end)

  it("should properly attach data", function()
    local s, data = spy.new(function() end), {}
    local function fun(e) s(e.data or "nil") end
    local handler1, handler2, eventObject = Event.newHandler(fun, data), Event.newHandler(fun), Event("test", parent)
    Event.addHandler(parent, "test", handler1)
    Event.addHandler(parent, "test", handler2)
    Event.triggerEvent(parent, "test", eventObject, 5, 10)
    assert.spy(s).was_called(2)
    assert.spy(s).was_called_with("nil")
    assert.spy(s).was_called_with(data)
  end)

  it("should be able to attach handlers using mixins", function()
    local s = spy.new(function() end)
    parent:on("test", function(_, ...) s(...) end)
    Event.triggerEvent(parent, "test", Event("test", parent), 5, 10)
    assert.spy(s).was_called(1)
    assert.spy(s).was_called_with(5, 10)
  end)

  it("should be able to trigger events using mixins", function()
    local s = spy.new(function() end)
    parent:on("test", function(_, ...) s(...) end)
    parent:trigger("test", 5, 10)
    assert.spy(s).was_called(1)
    assert.spy(s).was_called_with(5, 10)
  end)

  it("should be able to attach data using mixins", function()
    local s, data = spy.new(function() end), {}
    local function fun(e) s(e:getData() or "nil") end
    parent:on("test", fun)
    parent:on("test", data, fun)
    parent:trigger("test")
    assert.spy(s).was_called(2)
    assert.spy(s).was_called_with("nil")
    assert.spy(s).was_called_with(data)
  end)

  it("should only occurr once when using mixin function one()", function()
    local s1, s2 = spy.new(function() end), spy.new(function() end)
    parent:on("test", s1)
    parent:one("test", s2)
    parent:trigger("test")
    parent:trigger("test")
    assert.spy(s1).was_called(2)
    assert.spy(s2).was_called(1)
  end)

  it("should properly attach data when using one()", function()
    local s, data = spy.new(function() end), {}
    local function fun(e) s(e:getData() or "nil") end
    parent:one("test", data, fun)
    parent:one("test", fun)
    parent:trigger("test")
    parent:trigger("test")
    assert.spy(s).was_called(2)
    assert.spy(s).was_called_with("nil")
    assert.spy(s).was_called_with(data)
  end)

  it("should be able to remove handlers using off", function()
    local s = spy.new(function() end)
    parent:on("test", s)
    parent:trigger("test")
    parent:off("test", s)
    parent:trigger("test")
    assert.spy(s).was_called(1)
  end)

  it("should be able to remove all handlers using off", function()
    local s = spy.new(function() end)
    parent:on("test", s)
    parent:on("test", s)
    parent:trigger("test")
    parent:off("test")
    parent:trigger("test")
    assert.spy(s).was_called(2)
  end)

  it("should accept false as handler when using mixins", function()
    local s = spy.new(function() end)
    parent:on("test", s)
    child_a:one("test", false)
    child_a_a:on("test", false)
    child_a_a:trigger("test")
    child_a_a:trigger("test")
    child_a_a:off("test", false)
    child_a_a:trigger("test")
    child_a_a:trigger("test")
    assert.spy(s).was_called(1)
  end)

  it("should bubble up", function()
    local s1, s2 = spy.new(function() end), spy.new(function() end)
    child_a_a:on("test", s1)
    child_a:on("test", s1)
    child_b:on("test", s1)
    parent:on("test", s1)
    parent:on("test", function(_, ...) s2(...) end)
    parent:on("test", function(e) s2(e:getTarget()) end)
    child_a_a:trigger("test", 5, 10)
    assert.spy(s1).was_called(3)
    assert.spy(s2).was_called(2)
    assert.spy(s2).was_called_with(5, 10)
    assert.spy(s2).was_called_with(child_a_a)
  end)

  it("should be able to stop", function()
    local s = spy.new(function() end)
    child_a_a:on("test", s)
    child_a:on("test", function(e) e:stopPropagation() end)
    child_a:on("test", s)
    child_b:on("test", s)
    parent:on("test", s)
    child_a_a:trigger("test")
    assert.spy(s).was_called(2)
  end)

  it("should be able to stop immediately", function()
    local s = spy.new(function() end)
    child_a_a:on("test", s)
    child_a:on("test", function(e) e:stopImmediatePropagation() end)
    child_a:on("test", s)
    child_b:on("test", s)
    parent:on("test", s)
    child_a_a:trigger("test")
    assert.spy(s).was_called(1)
  end)

  it("should be able to remove by handler while traversing", function()
    local s = spy.new(function() end)
    local handler = Event.newHandler(s)
    parent:on("test", function() Event.removeHandler(parent, "test", handler) end)
    Event.addHandler(parent, "test", handler)
    parent:trigger("test")
    assert.spy(s).was_called(0)
  end)

  it("should be able to remove by handler twice while traversing", function()
    local s = spy.new(function() end)
    local handler1, handler2 = Event.newHandler(s),  Event.newHandler(s)
    Event.addHandler(parent, "test", handler1)
    parent:on("test", function()
      Event.removeHandler(parent, "test", handler1)
      Event.removeHandler(parent, "test", handler2)
    end)
    Event.addHandler(parent, "test", handler2)
    parent:trigger("test")
    parent:trigger("test")
    assert.spy(s).was_called(1)
  end)

  it("should be able to remove by function while traversing", function()
    local s1, s2 = spy.new(function() end), spy.new(function() end)
    parent:on("test", s1)
    parent:on("test", s2)
    parent:on("test", function() parent:off("test", s2) end)
    parent:on("test", s2)
    parent:on("test", s1)
    parent:trigger("test")
    parent:trigger("test")
    assert.spy(s1).was_called(4)
    assert.spy(s2).was_called(1)
  end)

  it("should be able to remove all function while traversing", function()
    local s1, s2 = spy.new(function() end), spy.new(function() end)
    parent:on("test", s1)
    parent:on("test", s2)
    parent:on("test", function() parent:off("test") end)
    parent:on("test", s2)
    parent:on("test", s1)
    parent:trigger("test")
    parent:trigger("test")
    assert.spy(s1).was_called(1)
    assert.spy(s2).was_called(1)
  end)
end)
