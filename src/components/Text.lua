local class = require "util.middleclass"
local component = require "util.component"
local property = require "util.property"

local Item = require "components.Item"

local fontDiretories = {
  ["OS X"] = "/Library/Fonts",
  ["Windows"] = "C:/Windows/Fonts/",
  ["Linux"] = "/usr/share/fonts"
}
-- TODO confirm and improve

local Text = class("Text", Item.class)

function Text:initialize(tbl)
  property(self, tbl, "text", "")

  property.group(self, tbl, "font", {
    size = 12,
    data = ""
  }, { -- flags
    data = { any = true }
  })
  component.functionBinding(function(font)
    if font.data and font.data ~= "" then
      local data = font.data
      if not love.filesystem.exists(data) then -- try to load from system fonts
        local f = io.open(fontDiretories[love.system.getOS()] .. data, "rb")
        data = love.filesystem.newFileData(f:read("*a"), data)
        f:close()
      end
      self._font = love.graphics.newFont(data, font.size)
    else
      self._font = love.graphics.newFont(font.size)
    end
  end, self.properties.font)()

  property(self, tbl, "color", {0, 0, 0})

  Item.class.initialize(self, component.evalArgs(self, nil, tbl))
end

function Text:draw()
  love.graphics.setColor(self.color)
  love.graphics.setFont(self._font)
  love.graphics.print(self.text, 0, 0)
end

return component(Text)
