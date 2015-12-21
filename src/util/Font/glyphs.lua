local glyphsets = {
  a = "abcdefghijklmnopqrstuvwxyz",
  A = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  d = "0123456789",
  s = " "
}

return setmetatable({}, {
  __index = function(_, key)
    local result = {}
    for c in string.gmatch(key, ".") do
      table.insert(result, glyphsets[c])
    end
    return table.concat(result)
  end, __newindex = function() end
})
