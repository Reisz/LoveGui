local class = require "lib.middleclass"

local FontRegistry = require "util.Font.Registry"
local FontObject = require "util.Font.Object"
local Utf8FontObject = require "util.Font.Utf8FontObject"

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

function FontEntry.static.load(name)
  if love.filesystem.isDirectory(name) then
    for _, v in ipairs(love.filesystem.getDirectoryItems(name)) do
      local n = name .. "/" .. v
      if love.filesystem.isFile(n) and string.find(v,"%.font%.lua$") then
        FontEntry.loadFile(n)
      end
    end
  else
    FontEntry.loadFile(name)
  end
end

local env = { Font = FontEntry }
function FontEntry.static.loadFile(filename)
  if _VERSION == "Lua 5.1" then
    local fn, msg = loadfile(filename)
    if not fn then error(msg) end
    setfenv(fn, env)()
  else -- Lua 5.2 or higher
    local fn, msg = loadfile(filename, "bt", env)
    if not fn then error(msg) end
    fn()
  end
end

function FontEntry:add(tbl)
  local font
  if tbl.type == "image" then
    font = FontObject(love.graphics.newImageFont(tbl.file, tbl.glyphs, tbl.extraspacing), tbl.size)
    local min, mag, ani = font:getFilter()
    font:setFilter(tbl.minFilter or min, tbl.magFilter or mag, tbl.anisotropy or ani)
  elseif tbl.type == "utf8" then
    font = Utf8FontObject(tbl.file, tbl)
    font:setFilter(tbl.minFilter or "nearest", tbl.magFilter or "nearest", tbl.anisotropy or 1)
  elseif tbl.type == "data" then
    font = love.filesystem.newFileData(tbl.file)
  end
  self:addVariant(font, tbl.weight, tbl.italic)
  return self -- for chaining (to add multiple entries to one family)
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

  local isData = false
  for i = 1, #self.dataVariants do
    local v = self.dataVariants[i]
    local sd, wd, im = 0, math.abs(weight - v.weight), italic == v.italic
    if sd == 0 and wd == 0 and im then
      return FontObject(v.data, size), true
    elseif match(sd, sizeDiff, wd, weightDiff, im, italicMatches) then
      bestMatch, sizeDiff, weightDiff, italicMatches, isData = v, sd, wd, im, true
    end
  end

  if isData then bestMatch = FontObject(bestMatch.data, size) end
  return bestMatch, sizeDiff == 0 and weightDiff == 0 and italicMatches
end

FontEntry.static.glyphs = require "util.Font.glyphs"

return FontEntry
