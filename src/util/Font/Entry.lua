local class = require "util.middleclass"

local FontRegistry = require "util.Font.Registry"
local FontObject = require "util.Font.Object"

local FontEntry = class("FontEntry")

function FontEntry:initialize(family)
  local entry = FontRegistry.getEntry(family)
  if entry then
    self.variants, self.dataVariants =
      entry.variants, entry.dataVariants
  else
    self.variants, self.dataVariants = {}, {}
    FontRegistry.add(family, self)
  end
end

function FontEntry:add(tbl)
  if tbl.type == "image" then
    local font = love.graphics.newImageFont(tbl.file, tbl.glyphs, tbl.extraspacing)
    local min, mag, ani = font:getFilter()
    font:setFilter(tbl.minFilter or min, tbl.magFilter or mag, tbl.anisotropy or ani)
    self:addVariant(FontObject(font, tbl.size), tbl.weight, tbl.italic)
  elseif tbl.type == "data" then
    self:addVariant(love.filesystem.newFileData(tbl.file), tbl.weight, tbl.italic)
  end
  return self
end

function FontEntry:addVariant(object, weight, italic)
  if FontObject.isInstanceOf(object, FontObject) then
    table.insert(self.variants, {
      object = object, size = object:getSize(), weight = weight, italic = italic
    })
  else
    table.insert(self.dataVariants, {
      data = object, weight = weight, italic = italic
    })
  end
end

function FontEntry:combineWith(other)
  local ov, odv = other.variants, other.dataVariants
  for i = 1, #ov do
    table.insert(self.variants, ov[i])
  end
  for i = 1, #odv do
    table.insert(self.dataVariants, odv[i])
  end
end

local function match(sd, sizeDiff, wd, weightDiff, im, italicMatches)
  if sd < sizeDiff then return true end
  if sd == sizeDiff and wd < weightDiff then return true end
  if sd == sizeDiff and wd == weightDiff and (not italicMatches and im) then return true end
  return false
end

function FontEntry:get(size, weight, italic)
  local bestMatch, sizeDiff, weightDiff, italicMatches = nil, math.huge, 100, false
  for i = 1, #self.variants do
    local v = self.variants[i]
    local sd, wd, im = math.abs(size - v.size), math.abs(weight - v.weight), italic == v.italic
    if sd == 0 and wd == 0 and im then
      return v.object, true
    elseif match(sd, sizeDiff, wd, weightDiff, im, italicMatches) then
      bestMatch, sizeDiff, weightDiff, italicMatches = v.object, sd, wd, im
    end
  end

  if sizeDiff <= size * 0.2 then sizeDiff = 0 end

  for i = 1, #self.dataVariants do
    local v = self.dataVariants[i]
    local sd, wd, im = 0, math.abs(weight - v.weight), italic == v.italic
    if sd == 0 and wd == 0 and im then
      return FontObject(v.data, size), true
    elseif match(sd, sizeDiff, wd, weightDiff, im, italicMatches) then
      bestMatch, sizeDiff, weightDiff, italicMatches = v, sd, wd, im
    end
  end

  if type(bestMatch) == "table" and bestMatch.data then
    bestMatch = FontObject(bestMatch.data, size)
  end
  return bestMatch, sizeDiff == 0 and weightDiff == 0 and italicMatches
end

FontEntry.static.glyphs = require "util.Font.glyphs"

return FontEntry
