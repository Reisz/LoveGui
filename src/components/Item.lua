local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"
local matcher = require "util.matching"
local version = require "util.version"

local Point = require "util.Point"
local Rect = require "util.Rect"

local Item = class("Item")

local function getCanvasFormatMatcher()
  if version >= version{0,9,2} then
    return "v{'" .. table.concat(love.graphics.getCanvasFormats(), "','") .. "'}"
  elseif version >= version{0,9,0} then
    return "v{'normal', 'hdr'}"
  end
  return "v{'normal'}"
end

local function getWrapModeValueMatcher()
  if version >= version{0,10,0} then
    return "v{'clamp', 'repeat', 'mirroredrepeat', 'clampzero'}"
  elseif version >= version{0,9,2} then
    return "v{'clamp', 'repeat', 'mirroredrepeat'}"
  end
  return "v{'clamp', 'repeat'}"
end

local function createCanvas(width, height, format, msaa, min, mag, ani, wrapMode)
  local result
  if version >= version{0,9,1} then
    result = love.graphics.newCanvas(width, height, format, msaa)
  elseif version >= version{0,9,0} then
    result = love.graphics.newCanvas(width, height, format)
  else
    result = love.graphics.newCanvas(width, height)
  end

  if version >= version{0,9,0} then
    result:setFilter(min, mag, ani)
  else
    result:setFilter(min, mag)
  end

  local wrapX, wrapY = wrapMode, wrapMode
  if type(wrapX) == "table" then
    wrapX = wrapX[1]
    wrapY = wrapY[2]
  end
  result:setWrap(wrapX, wrapY)

  return result
end

function Item:initialize(tbl)
  property(self, tbl, "x", 0)
  property(self, tbl, "y", 0)

  property(self, tbl, "width", 0)
  property(self, tbl, "height", 0)

  self.rect = Rect(0, 0, 0, 0)
  component.binding(self.rect, "x", self.properties.x)
  component.binding(self.rect, "y", self.properties.y)
  component.binding(self.rect, "width", self.properties.width)
  component.binding(self.rect, "height", self.properties.height)

  local function layer()
    if self.layer.enabled then
      self._canvas = createCanvas(self.width, self.height, self.layer.format,
        self.layer.msaa, self.layer.minFilter, self.layer.magFilter,
        self.layer.anisotropy, self.layer.wrapMode)
    end
  end
  component.functionBinding(layer,  self.properties.width)
  component.functionBinding(layer,  self.properties.height)

  property(self, tbl, "implicitWidth", 0)
  property(self, tbl, "implicitHeight", 0)

  local filterMatcher = matcher("v{'linear', 'nearest'}")
  local wm = getWrapModeValueMatcher()
	property.group(self, tbl, "layer", {
    enabled = false, format = "normal", msaa = 0,
    minFilter = "linear", magFilter = "linear", anisotropy = 1,
    wrapMode = "repeat"
  }, {
    format = getCanvasFormatMatcher(), shader = "may(l2t.Shader)",
    minFilter = filterMatcher, magFilter = filterMatcher,
    wrapMode = table.concat{"any{", wm,",tbl{", wm, ",", wm, "}}"}
  })
  component.functionBinding(layer, self.properties.layer)()

  property(self, tbl, "visible", true)

  property.default(self, tbl, "children", {})
end

function Item:draw()
  if not self.visible then return end
  self:cDraw()
end

function Item:cDraw()
  local children = self.children
  for i = #children, 1, -1 do
    local c = children[i]
    love.graphics.push()
    love.graphics.translate(c.x, c.y)
    c:cDraw()
    love.graphics.pop()
  end
end

function Item:update(dt)
  local children = self.children
  for i = 1, #children do
    children[i]:update(dt)
  end
end

function Item:childAt(x, y)
  local point = Point.resolveFunctionArgs(x, y)
  local children = self.children
  for i = #children, 1, -1 do
    if children[i]:conatins(point) then
      return children[i]
    end
  end
end

function Item:cointains(x, y)
  return self.rect:contains(x, y)
end

return component(Item)
