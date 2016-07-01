local Component = require "systems.Component"

-- stub all mixins

local mixinTables = { "mixin_initialize", "mixin_subclassed", "mixin_clone" }
for _,mixinTable in ipairs(mixinTables) do
  mock(Component[mixinTable], true)
end

describe("systems.Component", function()
  local snapshot

  before_each(function()
    snapshot = assert:snapshot()
  end)

  after_each(function()
    snapshot:revert()
  end)

  it("should initialize propertly", function()
    local parent = {}
    local c = Component(parent)
    for _,v in ipairs(Component.mixin_initialize) do
      assert.spy(v).was_called(1)
      assert.spy(v).was_called_with(c, parent)
    end
  end)

  it("should clone propertly", function()
    local c = Component()
    local other = c:clone()
    for _,v in ipairs(Component.mixin_clone) do
      assert.spy(v).was_called(1)
      assert.spy(v).was_called_with(c, other)
    end
  end)

  it("should clone propertly", function()
    local Item = Component:subclass("Item")
    for _,v in ipairs(Component.mixin_subclassed) do
      assert.spy(v).was_called(1)
      assert.spy(v).was_called_with(Component, Item)
    end
  end)

end)
