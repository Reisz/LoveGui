local version = {
  major = love._version_major,
  minor = love._version_minor,
  revision = love._version_revision
}

local function getNumbers(tbl)
  return tbl.major or tbl[1], tbl.minor or tbl[2], tbl.revision or tbl[3]
end

local mt; mt = {
  __eq = function(self, other)
    local x1, x2, x3 = getNumbers(self)
    local y1, y2, y3 = getNumbers(other)
    return x1 == y1 and x2 == y2 and x3 == y3
  end,
  __lt = function(self, other)
    local x1, x2, x3 = getNumbers(self)
    local y1, y2, y3 = getNumbers(other)
    return x1 < y1 or (x1 == y1 and x2 < y2) or (x1 == y1 and x2 == y2 and x3 < y3)
  end,
  __le = function(self, other)
    local x1, x2, x3 = getNumbers(self)
    local y1, y2, y3 = getNumbers(other)
    return x1 < y1 or (x1 == y1 and x2 < y2) or (x1 == y1 and x2 == y2 and x3 < y3)
      or (x1 == y1 and x2 == y2 and x3 == y3)
  end,
  __call = function(_, tbl) return setmetatable(tbl, mt) end
}

return setmetatable(version, mt)
