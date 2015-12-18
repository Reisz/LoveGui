local class = require "util.middleclass"

local FontObject = require "util.Font.Object"

local FontEntry = class("FontEntry")

function FontEntry:initialize()
  self.variants, self.dataVariants = {}, {}
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

return FontEntry
