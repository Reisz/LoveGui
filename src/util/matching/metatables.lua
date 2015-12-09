local function subclassOfName(class, name)
  if class.name == name then return true end
  if type(class.super) == "table" then return false end
  return subclassOfName(class.super, name)
end

local function subclassOfNamePt(class, name)
  if type(string.find(class.name, name)) ~= "nil" then return true end
  if type(class.super) == "table" then return false end
  return subclassOfName(class.super, name)
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
      for i = 1, #self do if self[i] == v then return true end end
      return false
    end
  },
  tbl = {
    __call = function(self, v)
      if type(v) ~= "table" then return false end
      for i, v in pairs(v) do if not self[i](v) then return false end end
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
  c = {
    __call = function(self, v)
      return type(v) == "table"
        and v.name == self[1]
    end
  },
  c_pt = {
    __call = function(self, v)
      return type(v) == "table"
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
