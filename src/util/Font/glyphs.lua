local glyphsets = {
  a = "abcdefghijklmnopqrstuvwxyz",
  A = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  d = "0123456789",
  s = " "
}

local glyphs = {}

-- TODO support all utf8 private use areas
function glyphs.getPrivateUsePoint(i)
  return string.char(238, 128, 129 + i)
end

local function subfn(op, num)
  num = tonumber(num)
  local t = type(num)
  if op == "u" and t == "number" then
    local result = {}
    for i = 1, num do
      table.insert(result, glyphs.getPrivateUsePoint(i))
    end
    return table.concat(result)
  elseif op == "u_" and t == "number" then
    return glyphs.getPrivateUsePoint(num)
  else
    return glyphsets[op] or ""
  end
end

return setmetatable(glyphs, {
  __index = function(self, key)
    return string.gsub(key, "([aAdsu]%_?)(%d*)", subfn)
  end, __newindex = function() end
})
