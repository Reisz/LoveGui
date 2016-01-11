local class = require "util.middleclass"

local FontRegistry = require "util.Font.Registry"

local Font = class("Font")

--- @param family [string]
--- @param size [number] in pixels
--- @param weight [number] 0 - 99
--- @param italic [boolean]
function Font:initialize(family, size, weight, italic)
  assert(type(family) == "string")
  assert(type(size) == "number")
  assert(type(weight) == "number")
  assert(type(italic) == "boolean")

  self.family = family
  self.size = size
  self.weight = weight
  self.italic = italic

  self:requery()

  self.underline = false
  self.strikeOut = false
  self.overline = false

  self.kerning = true
  self.ligatures = true

  self.filter = {}
end

function Font:requery()
  self.fontObject, self.exactMatch =
    FontRegistry.find(self.family, self.size, self.weight, self.italic)
  self.scaleFactor = self.size / self.fontObject:getSize()
  self:refresh()
end

--- @property family [string]
--- @read family
function Font:family()
  return self.family
end
--- @write family
function Font:setFamily(f)
  assert(type(f) == "string")
  self.family = f; self:requery()
end

--- @property size [number]
--- @read size
function Font:size()
  return self.size
end
--- @write size
function Font:setSize(s)
  assert(type(s) == "number")
  self.size = s; self:requery()
end

--- @property weight [number] 0 - 99
--- @read weight
function Font:weight()
  return self.weight
end
--- @write weight
function Font:setWeight(w)
  assert(type(w) == "number")
  self.weight = w; self:requery()
end

--- @property italic [boolean]
--- @read italic
function Font:italic()
  return self.italic
end
--- @write italic
function Font:setItalic(i)
  assert(type(i) == "boolean")
  self.italic = i; self:requery()
end

function Font:exactMatch()
  return self.exactMatch
end

--- @property underline [boolean] (false)
--- @read underline
function Font:underline()
  return self.underline
end
--- @write underline
function Font:setUnderline(ul)
  assert(type(ul) == "boolean")
  self.underline = ul
end

--- @property strikeOut [boolean] (false)
--- @read strikeOut
function Font:strikeOut()
  return self.strikeOut
end
--- @write strikeout
function Font:setStrikeOut(so)
  assert(type(so) == "boolean")
  self.strikeOut = so
end

--- @property overline [boolean] (false)
--- @read overline
function Font:overline()
  return self.overline
end
--- @write overline
function Font:setOverline(ol)
  assert(type(ol) == "boolean")
  self.overline = ol
end

--- @property kerning [boolean] (true)
--- @read kerning
function Font:kerning()
  return self.kerning
end
--- @write kerning
function Font:setKerning(k)
  assert(type(k) == "boolean")
  self.kerning = k
end

--- @property ligatures [boolean] (true)
--- @read ligatures
function Font:ligatures()
  return self.ligatures
end
--- @write ligatures
function Font:setLigatures(l)
  assert(type(l) == "boolean")
  self.ligatures = l
end

--- @property minFilter [string]
--- @read minFilter
function Font:minFilter()
  return self.filter.minFilter
end
--- @write minFilter
function Font:setMinFilter(mf)
  assert(type(mf) == "string")
  self.filter.minFilter = mf
end

--- @property magFilter [string]
--- @read magFilter
function Font:magFilter()
  return self.filter.magFilter
end
--- @write magFilter
function Font:setMagFilter(mf)
  assert(type(mf) == "string")
  self.filter.magFilter = mf
end

--- @property anisotropy [number] (1)
--- @read anisotropy
function Font:anisotropy()
  return self.filter.anisotropy
end
--- @write anisotropy
function Font:setAnisotropy(a)
  assert(type(a) == "number")
  self.filter.anisotropy = a
end

local function applyScale(factor, x, y, r, sx, sy, ...)
  r, sx, sy = r or 0, sx or 1, sy or 1
  sx, sy = sx * factor, sy * factor
  return x, y, r, sx, sy, ...
end

function Font:print(text, ...)
  self.fontObject:print(text, self.filter, applyScale(self.scaleFactor, ...))
end

--[[function Font:printf(text, x, v, limit, align, r, sx, sy, kx, ky)
  r, sx, sy = r or 0, sx or 1, sy or 1
  sx, sy = sx * self.scaleFactor, sy * self.scaleFactor
  self.fontObject:printf(text, self.filter, x, v, limit, align, r, sx, sy, kx, ky)
end]] -- TODO find replacement

function Font:prepare(text)
  self.prepQuery = text
  self:refresh()
end

function Font:getPreparedSize()
  local sf, w, h = self.scaleFactor, self.fontObject:getLayoutSize(self.layout)
  return w * sf, h * sf
end

function Font:refresh()
  local pq, fo = self.prepQuery, self.fontObject
  if pq then self.layout = fo:layout(pq) end
end

function Font:present(...)
  self.fontObject:present(self.layout, self.filter, applyScale(self.scaleFactor, ...))
end

return Font
