local Component = require "Systems.Component"

describe("Systems.Relationship", function()
  it("should enable basic relationship", function()
    local p = Component()
    local c1, c2 = Component(p), Component(p)
    assert.are.equal(p, c1:getParent())
    assert.are.equal(p, c2:getParent())
    assert.is_true(p:hasChild(c1))
    assert.is_true(p:hasChild(c2))
  end)
end)
