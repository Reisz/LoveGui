local FontObject = require "util.Font.Object"

local FontRegistry = { fonts = {}, sizes = {
    thin = 0, extralight = 12, light = 25,
    normal = 50, medium = 57, demibold = 63,
    bold = 75, extrabold = 81, black = 99,
    [0] = "Thin", [12] = "ExtraLight", [25] = "Light",
    [50] = "Normal", [57] = "Medium", [63] = "DemiBold",
    [75] = "Bold", [81] = "ExtraBold", [99] = "Black"
  }
}

function FontRegistry.find(family, size, weight, italic)
  if family == "" then
    return FontObject(love.graphics.newFont(size), size), weight == 50 and italic == false
  end

  local fontEntry = FontRegistry.fonts[family]
  if fontEntry then
    return fontEntry:get(size, weight, italic)
  else
    -- TODO system font finder
    return FontObject(love.graphics.newFont(size), size), false
  end
end

function FontRegistry.add(family, entry)
  assert(type(family) == "string" and family ~= "")
  local e = FontRegistry.fonts[family]
  if e then
    e:combineWith(entry)
  else
    FontRegistry.fonts[family] = entry
  end
end

-- TODO load fonts at startup

return FontRegistry
