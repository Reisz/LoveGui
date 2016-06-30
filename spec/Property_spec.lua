local Component = require "systems.Component"

describe("systems.Property", function()
  it("should add all expected methods", function()
    local c = Component()
    assert.are.equal("function", type(c.hasProperty))
    assert.are.equal("function", type(c.clear))
    assert.are.equal("function", type(c.get))
    assert.are.equal("function", type(c.set))
    assert.are.equal("function", type(c.getMatcher))
    assert.are.equal("function", type(c.setMatcher))
    assert.are.equal("function", type(c.create))
  end)

  it("should be able to dynamically add properties", function()
    local c = Component()
    c:set("test1", 3)
    c:set("test2", "hello")

    assert.is_true(c:hasProperty("test1"))
    assert.is_true(c:hasProperty("test2"))
  end)

  it("should be able to set matchers", function()
    local c = Component()
    c:set("test1", 3)
    c:set("test2", 5)
    local m = function(v) return type(v) == "number" end
    c:setMatcher("test2", m)

    assert.is_true(c:hasProperty("test1"))
    assert.is_true(c:hasProperty("test2"))
    assert.are.equal("nil", type(c:getMatcher("test1")))
    assert.are.equal(m, c:getMatcher("test2"))
  end)

  it("should be able to recognize properties by setting matchers", function()
    local c = Component()
    c:setMatcher("test1", function() return true end)
    assert.is_true(c:hasProperty("test1"))
    c:setMatcher("test1")
    assert.is_false(c:hasProperty("test1"))
  end)

  it("should be able to initialize properties with nil", function()
    local c = Component()
    c:set("test1", nil)
    assert.is_true(c:hasProperty("test1"))
    assert.are.equal("nil", type(c:get("test1")))
  end)

  it("should be able to clear properties", function()
    local c = Component()
    c:set("test1", 3)
    c:set("test2", 5)
    local m = function(v) return type(v) == "number" end
    c:setMatcher("test2", m)

    assert.is_true(c:hasProperty("test1"))
    assert.is_true(c:hasProperty("test2"))

    c:clear("test1")
    c:clear("test2")

    assert.is_false(c:hasProperty("test1"))
    assert.is_false(c:hasProperty("test2"))
  end)

  it("should warn when trying to clear non-existent properties", function()
    local debug = require "systems.debug"
    mock(debug, true)

    local c = Component()
    c:clear("test")
    assert.stub(debug.warn).was_called(1)

    mock.revert(debug)
  end)

  it("should fail on incompatible types", function()
    local c = Component()
    local m = function(v) return type(v) == "number" end
    c:setMatcher("test1", m)

    assert.has_error(function() c:set("test1", "hi") end)
    assert.has_no.error(function() c:set("test1", 1) end)
    assert.are.equal(1, c:get("test1"))
  end)

  it("should be able to use __index and __newindex", function()
    local c = Component()
    c.test1 = 3
    assert.are.equal(3, c.test1)
    c.test1 = nil
    assert.are.equal("nil", type(c.test1))
  end)

  describe("Object Properties", function()
    local matchidx = {} -- to prevent accidental coupling
    local wrapper = mock{
      initialize = function(self) return setmetatable({},
        { __index = self })
      end,
      clone = function() end,
      setMatcher = function(self, m) self[matchidx] = m end,
      getMatcher = function(self) return self[matchidx] end
    }

    it("should be able to create a new object property", function()
      local match = require "luassert.match"
      local c = Component()

      local w = c:create("test", wrapper)
      assert.are_not.equal(wrapper, w)
      assert.spy(wrapper.initialize).was_called_with(wrapper, match._, "test")
      assert.spy(w.initialize).was_called(1)
      assert.spy(w.clone).was_called(0)
      assert.spy(w.setMatcher).was_called(0)
      assert.spy(w.getMatcher).was_called(0)
    end)

    it("should load object property types by name", function()
      local _require = spy.new(function() return wrapper end)
      local env = setmetatable({ require = _require }, { __index = _G })

      local c = Component()
      if _VERSION == "Lua 5.1" then
        local uv = getfenv(c.create)
        setfenv(c.create, env)(c, "test", "Test")
        setfenv(c.create, uv)
      else -- Lua 5.2 or higher
        -- simulate setfenv
        local function findenv(f)
          local level = 1
          repeat
            local name, value = debug.getupvalue(f, level)
            if name == '_ENV' then return level, value end
            level = level + 1
          until name == nil
          return nil
        end
        local level, uv = findenv(c.create)
        debug.setupvalue(c.create, level, env)
        c:create("test", "Test")
        debug.setupvalue(c.create, level, uv)
      end

      assert.spy(_require).was_called_with("systems.Property.Test")
    end)

    it("should fail when overwriting existing properties", function()
      local c = Component()

      c.test = "a"
      assert.has_error(function() c:create("test", wrapper) end)
      assert.are.equal("a", c.test)
    end)

    it("should fail when overwriting existing object properties", function()
      local c = Component()

      local w = c:create("test", wrapper)
      assert.has_error(function() c.test = "a" end)
      assert.are.equal(w, c.test)
    end)

    it("should properly clear object properties", function()
      local c = Component()

      local w = c:create("test", wrapper)
      assert.is_true(c:hasProperty("test"))
      c:clear("test")
      assert.are_not.equal(w, c.test)
      assert.has_no.errors(function() c.test = "a" end)
    end)

    it("should properly set matchers on object properties", function()
      local c = Component()
      local m = function(v) return type(v) == "number" end

      local w = c:create("test", wrapper)
      c:setMatcher("test", m)
      assert.are.equal(m, w:getMatcher())
    end)

    it("should properly get matchers from object properties", function()
      local c = Component()
      local m = function(v) return type(v) == "number" end

      local w = c:create("test", wrapper)
      w:setMatcher(m)
      assert.are.equal(m, c:getMatcher("test"))
    end)
  end)

  describe("Cloning", function()
    it("should clone properties", function()
      local c = Component()
      c.test = "hi"
      local clone = c:clone()
      assert.are.equal("hi", clone.test)
      c.hello = "world"
      assert.are.equal("world", clone.hello)
    end)

    it("should update cloned properties", function()
      local c = Component()
      c.test = "hello"
      local clone = c:clone()
      assert.are.equal("hello", clone.test)
      c.test = "world"
      assert.are.equal("world", clone.test)
    end)

    it("should be able to overwrite cloned propeties", function()
      local c = Component()
      c.test = "hello"
      local clone = c:clone()
      assert.are.equal("hello", clone.test)
      clone.test = "test"
      c.test = "world"
      assert.are.equal("test", clone.test)
    end)

    it("should be able to overwrite cloned propeties with nil", function()
      local c = Component()
      c.test = "hello"
      local clone = c:clone()
      assert.are.equal("hello", clone.test)
      clone.test = nil
      c.test = "world"
      assert.are.equal("nil", type(clone.test))
    end)

    it("should be able to clear overwerites", function()
      local c = Component()
      c.test = "hello"
      local clone = c:clone()
      assert.are.equal("hello", clone.test)
      clone.test = "test"
      c.test = "world"
      assert.are.equal("test", clone.test)
      clone:clear("test")
      assert.are.equal("world", clone.test)
    end)

    it("should be able to clone/overwrite/reset matchers", function()
      local m1 = function(v) return type(v) == "number" end
      local m2 = function(v) return type(v) == "string" end

      local c = Component()
      local clone = c:clone()

      c:setMatcher("test", m1)
      assert.has.error(function() clone.test = "hi" end)
      assert.has_no.error(function() clone.test = 3 end)
      clone:setMatcher("test", m2)
      assert.has.error(function() clone.test = 3 end)
      assert.has_no.error(function() clone.test = "hi" end)
      clone:setMatcher("test")
      assert.has.error(function() clone.test = "hi" end)
      assert.has_no.error(function() clone.test = 3 end)
    end)

  end)
end)
