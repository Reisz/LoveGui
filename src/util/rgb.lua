-- support for html/css color plugins
local function rgb(r, g, b) return {r, g, b} end
local function rgba(r, g, b, a) return {r, g, b, a * 255} end
return function()
  return rgb, rgba
end
