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

  it("should fail on incompatible types", function()
    local c = Component()
    local m = function(v) return type(v) == "number" end
    c:setMatcher("test1", m)

    assert.has_error(function() c:set("test1", "hi") end)
    assert.has_no.error(function() c:set("test1", 1) end)
    assert.are.equal(1, c:get("test1"))
  end)

  describe("Object Properties", function()
    -- TODO
  end)
end)
