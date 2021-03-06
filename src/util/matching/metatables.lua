local function subclassOfName(class, name)
  if class.name == name then return true end
  if type(class.super) ~= "table" then return false end
  return subclassOfName(class.super, name)
end

local function subclassOfNamePt(class, name)
  if type(class.name) ~= "string" then return false end
  if type(string.find(class.name, name)) ~= "nil" then return true end
  if type(class.super) ~= "table" then return false end
  return subclassOfNamePt(class.super, name)
end

return {
  all = {
    __call = function(self, ...)
      for i = 1, #self do if not self[i](...) then return false end end
      return true
    end
  },
  any = {
    __call = function(self, ...)
      for i = 1, #self do if self[i](...) then return true end end
      return false
    end
  },
  may = {
    __call = function(self, v)
      if type(v) == "nil" then return true end
      return self[1](v)
    end
  },
  v = {
    __call = function(self, v)
      if self[v] then return true end
      return false
    end
  },
  tbl = {
    __call = function(self, v)
      if type(v) ~= "table" then return false end
      for i,_v in pairs(v) do
        local f = self[i]; if not(f and f(_v)) then return false end end
      return true
    end
  },
  list = {
    __call = function(self, v)
      if type(v) ~= "table" then return false end
      local matcher, size = self[1], #v
      local min, max = self[2], self[3]

      if not max then
        if min and size ~= min then return false end
      else
        if min >= 0 and min > size then return false end
        if max >= 0 and max < size then return false end
      end

      for i=1, size do
        if not matcher(v[i]) then return false end
      end

      return true
    end
  },
  pt = {
    __call = function(self, v)
      return type(v) == "string"
        and type(string.find(v, self[1])) ~= "nil"
    end
  },
  ts = {
    __call = function(self, v)
      return tostring(v) == self[1]
    end
  },
  ts_pt = {
    __call = function(self, v)
      return type(string.find(tostring(v), self[1])) ~= "nil"
    end
  },
  tn = {
    __call = function(self, v)
      return tonumber(v) == self[1]
    end
  },
  c = {
    __call = function(self, v)
      return type(v) == "table"
        and v.name == self[1]
    end
  },
  c_pt = {
    __call = function(self, v)
      return type(v) == "table"
        and type(v.name) == "string"
        and type(string.find(v.name, self[1])) ~= "nil"
    end
  },
  o = {
    __call = function(self, v)
      return type(v) == "table"
        and type(v.class) == "table"
        and subclassOfName(v.class, self[1])
    end
  },
  o_pt = {
    __call = function(self, v)
      return type(v) == "table"
        and type(v.class) == "table"
        and subclassOfNamePt(v.class, self[1])
    end
  },
  subc = {
    __call = function(self, v)
      return type(v) == "table"
        and subclassOfName(v, self[1])
    end
  },
  subc_pt = {
    __call = function(self, v)
      return type(v) == "table"
        and subclassOfNamePt(v, self[1])
    end
  },
  l2t = {
    __call = function(self, v)
      return type(v) == "userdata"
        and v.typeOf and v:typeOf(self[1])
    end
  },
}
