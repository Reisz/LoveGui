local Component = require "systems.Component"

describe("Systems.Relationship", function()
  it("should enable basic relationship", function()
    local p = Component()
    local c1, c2 = Component(p), Component(p)
    assert.are.equal(p, c1:getParent())
    assert.are.equal(p, c2:getParent())
    assert.is_true(p:hasChild(c1))
    assert.is_true(p:hasChild(c2))
  end)

  it("should be able to switch parents", function()
    local p1, p2 = Component(), Component()
    local c = Component(p1)

    assert.are.equal(p1, c:getParent())
    assert.is_true(p1:hasChild(c))
    assert.is_false(p2:hasChild(c))

    c:setParent(p2)
    assert.are.equal(p2, c:getParent())
    assert.is_true(p2:hasChild(c))
    assert.is_false(p1:hasChild(c))
  end)

  -- TODO cloning tests
end)
