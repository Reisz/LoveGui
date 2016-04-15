local version = require "util.version"

local util = {}

function util.getCanvasFormatMatcher()
  if version >= version{0,9,2} then
    local result = {"v{"}
    for i,v in pairs(love.graphics.getCanvasFormats()) do
      if v then
        table.insert(result, "'")
        table.insert(result, i)
        table.insert(result, "',")
      end
    end
    table.insert(result, "}")
    return table.concat(result)
  elseif version >= version{0,9,0} then
    return "v{'normal', 'hdr'}"
  end
  return "v{'normal'}"
end

function util.getWrapModeValueMatcher()
  if version >= version{0,10,0} then
    return "v{'clamp', 'repeat', 'mirroredrepeat', 'clampzero'}"
  elseif version >= version{0,9,2} then
    return "v{'clamp', 'repeat', 'mirroredrepeat'}"
  end
  return "v{'clamp', 'repeat'}"
end

function util.getWrapModeMatcher()
  local wm = util.getWrapModeValueMatcher()
  return table.concat{"any{", wm, ",tbl{", wm, ",", wm, "}}"}
end

return util
