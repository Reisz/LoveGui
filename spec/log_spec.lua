describe("systems.log", function()
  it("delegates everything anyway", function()
    local log = require "systems.log"
    local s = spy(function() end)
    log.print = s
    
    log.info("")
    assert.spy(s).was_called(1)
    log.warn("")
    assert.spy(s).was_called(2)
    log.error("")
    assert.spy(s).was_called(3)
    log.fatal("")
    assert.spy(s).was_called(4)
  end)
end)
