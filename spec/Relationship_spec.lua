local Component = require "systems.Component"

describe("Systems.Relationship", function()
  it("should enable basic relationship", function()
    local p = Component()
    local c1, c2 = Component(p), Component(p)
    assert.is_true(p:hasChild(c1))
    assert.is_true(p:hasChild(c2))
  end)

  it("should be able to switch parents", function()
    local p1, p2 = Component(), Component()
    local c = Component(p1)

    assert.is_true(p1:hasChild(c))
    assert.is_false(p2:hasChild(c))

    p1:removeChild(c)
    p2:addChild(c)
    assert.is_true(p2:hasChild(c))
    assert.is_false(p1:hasChild(c))
  end)

  it("should apply changes from cloned children", function()
    local p1 = Component()
    local c = Component(p1)
    local p2 = p1:clone()

    assert.is_true(p2:hasChild(c))
    c.test = 123
    local test; for child in p2:children() do test = child.test end
    assert.are_same(123, test)
  end)

  it("should add children added after cloning", function()
    local p1 = Component()
    local p2 = p1:clone()
    local c = Component(p1)

    assert.is_true(p2:hasChild(c))
  end)

  it("should be able to overwrite cloned children", function()
    local p1 = Component()
    local c1 = Component(p1)
    local p2 = p1:clone()

    assert.is_true(p2:hasChild(c1))
    p2:removeChild(c1)
    assert.is_false(p2:hasChild(c1))

    local c2 = Component(p2)
    assert.is_false(p1:hasChild(c2))
    assert.is_true(p2:hasChild(c2))
  end)

  it("should find children in all cloning layers", function()
    local p1 = Component()
    local p2 = p1:clone()
    local p3 = p2:clone()

    -- define finding utility
    local children, found = { Component(), Component(), Component() }
    local function find(a)
      for i,v in ipairs(children) do if v == a then return i end end
    end
    local function findChildren(asserts)
      found = { false, false, false }
      for c in p3:children() do found[find(c)] = true end
      for i, v in ipairs(found) do assert.are_equal(asserts[i], v) end
    end

    findChildren{false, false, false}
    p1:addChild(children[1])
    findChildren{true, false, false}
    p2:addChild(children[2])
    findChildren{true, true, false}
    p3:addChild(children[3])
    findChildren{true, true, true}
  end)

  it("should be able to remove children in any layer", function()
    local p1 = Component()
    local p2 = p1:clone()
    local p3 = p2:clone()

    -- not present
    local c = Component()
    assert.is_false(p3:hasChild(c))
    -- present in p1
    p1:addChild(c)
    assert.is_true(p3:hasChild(c))
    -- removed from p1
    p1:removeChild(c)
    assert.is_false(p3:hasChild(c))
    -- present in p1
    p1:addChild(c)
    assert.is_true(p3:hasChild(c))
    -- present in p1, removed in p2
    p2:removeChild(c)
    assert.is_false(p3:hasChild(c))
    -- readded in p2
    p2:addChild(c)
    assert.is_true(p3:hasChild(c))
    -- present in p2, removed in p3
    p3:removeChild(c)
    assert.is_false(p3:hasChild(c))
    -- readded in p3
    p3:addChild(c)
    assert.is_true(p3:hasChild(c))
  end)
end)
