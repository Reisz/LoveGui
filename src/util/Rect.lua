local class = require "util.middleclass"

local Point = require "util.Point"
local Size = require "util.Size"

local Rect = class("Rect")

function Rect:initialize(x, y, width, height)
  local point, size
  if type(x) == "table" then
    point, size = Point(x), Size(y, height)
  else
    point, size = Point(x, y), Size(width, height)
  end
  self.point, self.size = point, size
end

function Rect:contains(x, y)
  local point = Point.resolveFunctionArgs(x, y)
  local topleft, bottomright = self.point, self.point + self.size
  return topleft.x <= point.x and topleft.y <= point.y
    and bottomright.x >= point.x and bottomright.y >= point.y
end

return Rect
