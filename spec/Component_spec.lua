local Component = require "systems.Component"


describe("systems.Component", function()
  -- stub all mixins
  local mixinTables = { "mixin_initialize", "mixin_subclassed", "mixin_clone" }

  before_each(function()
    for _,mixinTable in ipairs(mixinTables) do
      table.insert(Component[mixinTable], function() end)
      mock(Component[mixinTable], true)
    end
  end)

  after_each(function()
    for _,mixinTable in ipairs(mixinTables) do
      mock.revert(Component[mixinTable])
      table.remove(Component[mixinTable])
    end
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

  it("should subclass propertly", function()
    local Item = Component:subclass("Item")
    for _,v in ipairs(Component.mixin_subclassed) do
      assert.spy(v).was_called(1)
      assert.spy(v).was_called_with(Component, Item)
    end
  end)

  it("should initialize subclasses properly", function()
    local Item = Component:subclass("Item")
    local parent = {}
    local i = Item(parent)

    for _,v in ipairs(Component.mixin_initialize) do
      assert.spy(v).was_called(1)
      assert.spy(v).was_called_with(i, parent)
    end
  end)

  it("should clone subclasses properly", function()
    local Item = Component:subclass("Item")
    local i = Item()
    local other = i:clone()

    for _,v in ipairs(Component.mixin_clone) do
      assert.spy(v).was_called(1)
      assert.spy(v).was_called_with(i, other)
    end
  end)
end)
