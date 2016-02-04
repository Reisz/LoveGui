local FontObject = require "util.Font.Object"

local FontRegistry = { fonts = {}, weights = {
    thin = 0, extralight = 12, light = 25,
    normal = 50, medium = 57, demibold = 63,
    bold = 75, extrabold = 81, black = 99,
    [0] = "thin", [12] = "extralight", [25] = "light",
    [50] = "book", [57] = "normal", [63] = "demibold",
    [75] = "bold", [81] = "extrabold", [99] = "black"
  },
}

local function getFcName(weight)
  if weight < 12 then return "thin"
  elseif weight < 25 then return "extralight"
  elseif weight < 50 then return "light"
  elseif weight < 57 then return "book"
  elseif weight < 63 then return "normal"
  elseif weight < 75 then return "demibold"
  elseif weight < 81 then return "bold"
  elseif weight < 99 then return "extrabold"
  else return "black" end
end

local os = love._os or love.system.getOS()
if os == "Windows" then
  function FontRegistry.findSystem(family, weight, italic) -- luacheck: no unused args
    -- TODO windows system font management (font file parsing)
  end
else
  function FontRegistry.findSystem(family, weight, italic)
    local fontMatcher = {'fc-match -f%{file} "', family }
    if italic then table.insert(fontMatcher, ":italic") end

    table.insert(fontMatcher, ":weight=")
    local w = FontRegistry.weights[weight]
    if not w then w = getFcName(weight) end
    table.insert(fontMatcher, w)

    table.insert(fontMatcher, '"')
    local process = assert(io.popen(table.concat(fontMatcher), "r"))
    local fileName = assert(process:read("*a"))
    process:close()

    if fileName ~= "" then
      local file = assert(io.open(fileName, "rb"))
      local content = assert(file:read("*all"))
      file:close()
      return love.filesystem.newFileData(content, "loaded font"), false -- TODO detect
    end
  end
end

function FontRegistry.find(family, size, weight, italic)
  if family == "" then
    return FontObject(love.graphics.newFont(size), size), weight == 50 and italic == false
  end

  if type(weight) == "string" then weight = FontRegistry.weights[weight] end

  local fontEntry = FontRegistry.fonts[family]
  if fontEntry then
    return fontEntry:get(size, weight, italic)
  else
    local data, match = FontRegistry.findSystem(family, weight, italic)
    if data then
      return FontObject(data, size), match
    else
      return FontObject(love.graphics.newFont(size), size), false
    end
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

function FontRegistry.getEntry(family)
  return FontRegistry.fonts[family]
end

-- TODO load fonts at startup

return FontRegistry
