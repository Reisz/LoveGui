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

  -- TODO

end)
