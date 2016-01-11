local utf8 = require "utf8"
local class = require "util.middleclass"
local version = require "util.version"
local glyphsUtil = require "util.Font.glyphs"
local FontObject = require "util.Font.Object"

local Utf8FontObject = class("Utf8FontObject", FontObject)
local removeSepColShader = love.graphics.newShader [[
  extern vec4 sepCol;

  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 c = Texel(texture, texture_coords);
    if(c == sepCol) c = vec4(0,0,0,0);
    return c * color;
  }
]]

local function loadFile(fileName)
  if type(fileName) ~= "string" then return fileName end
  if love.filesystem.isFile(fileName) then
    return love.image.newImageData(fileName)
  else
    local file = assert(io.open(fileName, "rb"))
    local content = assert(file:read("*a"))
    file:close()
    return love.image.newImageData(content)
  end
end

local function canvasDraw(drawable, shader)
  local canvas = love.graphics.newCanvas(drawable:getWidth(), drawable:getHeight())
  local oldShader = love.graphics.getShader()
  love.graphics.setShader(shader)
  love.graphics.setCanvas(canvas)
  love.graphics.draw(drawable, 0, 0)
  love.graphics.setCanvas()
  love.graphics.setShader(oldShader)
  return canvas
end

local getIDMethod = version < version{0,10,0} and "getImageData" or "newImageData"
local function toImageData(image)
  local t = type(image)
  if t == "table" and type(t.getPixel) == "function" then
    return image
  elseif t == "userdata" then
    if image:typeOf("ImageData") then return image end

    -- convert compressed image data to image
    if image:typeOf("CompressedImageData") then image = love.graphics.newImage(image) end

    -- do a canvas draw when getData wont return ImageData
    if image:typeOf("Image") then
      if version < version{0,9,0} or image:isCompressed() then
        image = canvasDraw(image)
      else
        return image:getData()
      end
    end

    -- version safe getImageData
    if image:typeOf("Canvas") then return image[getIDMethod](image) end
  end
end

local function combineSet(set)
  local chars = {}
  for i in pairs(set) do table.insert(chars, i) end
  return table.concat(chars)
end

local function getMatcher(ligatures)
  local chars = {{}}
  for s in pairs(ligatures) do
    while #chars < #s do table.insert(chars, {}) end
    local i = 1
    for c in s:gmatch(".") do chars[i][c] = true; i = i + 1 end
  end

  for i,v in ipairs(chars) do chars[i] = combineSet(v) end
  return table.concat{"[", table.concat(chars, "]?["), "]?"}
end

function Utf8FontObject:initialize(image, data, size)
  self.data = data

  -- detect quads using getPixel from ImageData
  image = loadFile(image); image = toImageData(image)
  local quads, r, g, b, a = Utf8FontObject.getQuads(image)
  self.image = love.graphics.newImage(image)


  self.height = self.image:getHeight() -- TODO customizable

  -- remove seperators to prevent bleeding
  removeSepColShader:send("sepCol", {r / 255, g / 255, b / 255, a / 255})
  self.image = canvasDraw(self.image, removeSepColShader)
  local min, mag, ani = self.image:getFilter()
  self.image:setFilter(data.minFilter or min, data.magFilter or mag, data.anisotropy or ani)

  -- assign quads to glyphs, check discrepancies
  local glyphs, idx = {}, 1
  for _, c in utf8.codes(data.glyphs) do
    glyphs[c] = quads[idx]; idx = idx + 1
  end
  local gc, dq = idx - 1, #quads
  if gc ~= dq then
    print(string.format("Warning: Glyphcount(%d) does not match determined quads(%d)!", gc, dq))
  end
  self.glyphs = glyphs

  -- generate automatic ligatures
  self.ligatures = data.ligatures or {}
  if data.autolig then
    for i, v in ipairs(data.autolig) do
    	self.ligatures[v] = glyphsUtil.getPrivateUsePoint(i)
    end
  end
  self.ligMatcher = getMatcher(self.ligatures)

  -- prepare kerning table
  self.kerning = data.kerning or {}

  local kf = data.autokern
  if kf then for i = 1, #kf, 3 do
    local kern = kf[i + 2]
    for _, code in utf8.codes(kf[i]) do
      for _, c in utf8.codes(kf[i + 1]) do
        local ktbl = self.kerning[c]
        if not ktbl then ktbl = {}; self.kerning[c] = ktbl end
        ktbl[code] = kern
      end
    end
  end end
end

function Utf8FontObject.static.getQuads(image)
  local quads = {}
  local r1, g1, b1, a1 = image:getPixel(0, 0)
  local width, height, quadStart = image:getWidth(), image:getHeight(), 1
  for i = 1, width - 1 do
    local r2, g2, b2, a2 = image:getPixel(i, 0)
    if r1 == r2 and g1 == g2 and b1 == b2 and a1 == a2 then
      if quadStart ~= i then
        table.insert(quads, love.graphics.newQuad(quadStart, 0, i - quadStart, height, width, height))
      end
      quadStart = i + 1
    end
  end
  return quads, r1, g1, b1, a1
end

local sbMethod = version >= version{0,9,0} and "add" or "addq"
function Utf8FontObject:getSpriteBatch(text)
  local x, y, w, h = 0, 0, 0, self.height
  local batch = love.graphics.newSpriteBatch(self.image, utf8.len(text), "static")
  local gl, kern = self.glyphs, self.kerning
  text = text:gsub(self.ligMatcher, self.ligatures)

  local prev
  for _,c in utf8.codes(text) do
    if c == 10 then
      w, h = x > w and x or w, h + self.height
      x, y, prev = 0, y + self.height, nil
    else
      local quad = gl[c]
      if quad then
        if prev and kern[c] then x = x + (kern[c][prev] or 0) end; prev = c
        batch[sbMethod](batch, quad, x, y)
        x = x + select(3, quad:getViewport())
      end
    end
  end

  return batch, x > w and x or w, h
end

local function filterDraw(drawable, image, filter, ...)
  local mif, maf, ani = image:getFilter()
  image:setFilter(filter.minFilter or mif, filter.magFilter or maf, filter.anisotropy or ani)
  love.graphics.draw(drawable, ...)
  image:setFilter(mif, maf, ani)
end

function Utf8FontObject:print(text, filter, x, y, r, sx, sy, kx, ky)
  -- TODO cache
  filterDraw(self:getSpriteBatch(text), self.image, filter, x, y, r, sx, sy, 0, 0, kx, ky)
end
function Utf8FontObject:printf(text, filter, x, v, limit, align, r, sx, sy, kx, ky) end

function Utf8FontObject:layout(text)
  local sb, w, h = self:getSpriteBatch(text)
  return { sb = sb, width = w, height = h }
end

function Utf8FontObject:present(layout, filter, ...)
  filterDraw(layout.sb, self.image, filter, ...)
end

function Utf8FontObject:getAscent() return self.data.ascent end
function Utf8FontObject:getBaseline() return self.data.baseline end
function Utf8FontObject:getDescent() return self.data.descent end

function Utf8FontObject:getFilter()
  local sd = self.data; return sd.minFilter, sd.magFilter, sd.anisotropy
end
function Utf8FontObject:setFilter(minFilter, magFilter, anisotropy)
  local sd = self.data
  sd.minFilter = minFilter or sd.minFilter
  sd.magFilter = magFilter or sd.magFilter
  sd.anisotropy = anisotropy or sd.anisotropy
end

function Utf8FontObject:getWidth(text)
  local w, maxw = 0, 0
  local gl, kern = self.glyphs, self.kerning
  text = text:gsub(self.ligMatcher, self.ligatures)

  local prev
  for _,c in utf8.codes(text) do
    if c == 10 then
      maxw, w = w > maxw and w or maxw, 0
    else
      local quad = gl[c]
      if quad then
        if prev and kern[c] then w = w + (kern[c][prev] or 0) end; prev = c
        w = w + select(3, quad:getViewport())
      end
    end
  end

  return maxw
end

function Utf8FontObject:getHeight() return self.data.height end
function Utf8FontObject:getSize() return self.data.size end

return Utf8FontObject
