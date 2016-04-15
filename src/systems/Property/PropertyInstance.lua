local hasEvent = ""
local PropertyInstance = {}

function PropertyInstance:get()
  return self.value
end

function PropertyInstance:set(value)
  if self.matcher(value) then
    local oldVal = self.value
    self.value = value
    self.instance:trigger(self, value, oldVal)
  end
end

function PropertyInstance:_set(value)
  self.value = value
end

return { __index = PropertyInstance }
