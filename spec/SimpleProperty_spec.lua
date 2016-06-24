--                                                                                                                                                                                             
local Component = require "systems.Component"

describe("systems.Property.SimpleProperty", function()
  it("should create new properties", function()
    local classA = Component:subclass("A")
    local p = classA:addProperty("test")
    assert.are.equal(p, classA.properties.test)
  end)
  it("should assign values properly", function()
    local classA = Component:subclass("A")
    local p = classA:addProperty("test"):set(3)
    assert.are.equal(3, classA.properties.test:get())
    p:set(7)
    assert.are.equal(7, p:get())
  end)
end)
