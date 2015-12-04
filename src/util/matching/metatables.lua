local function instanceOfName(class, name)
  if class.name == name then return true end
  if type(class.super) == "table" then return false end
  return instanceOfName(class.super, name)
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
  v = {
    __call = function(self, v)
      for i = 1, #self do if self[i] == v then return true end end
      return false
    end
  },
  tbl = {
    __call = function(self, v)
      for i = 1, #self do if not self[i](v) then return false end end
      return true
    end
  },
  ts = {
    __call = function(self, v)
      return tostring(v) == self[1]
    end
  },
  c = {
    __call = function(self, v)
      return type(v) == "table"
        and v.name == self[1]
    end
  },
  o = {
    __call = function(self, v)
      return type(v) == "table"
        and type(v.class) == "table"
        and instanceOfName(v.class, self[1])
    end
  },
  subC = {
    __call = function(self, v)
      -- TODO
    end
  },
  supC = {
    __call = function(self, v)
      -- TODO
    end
  },
}
