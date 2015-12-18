local rgb, rgba = require "util.rgb" ()

local Item = require "components.Item"
local Text = require "components.Text"

--- TODO simplify, maybe load a folder "fonts"
local FontEntry = require "util.Font.Entry"
local FontObject = require "util.Font.Object"
local tutorialEntry = FontEntry()
tutorialEntry:addVariant(
  FontObject(love.graphics.newImageFont("imagefont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")),
  17, 50, false);
(require "util.Font.Registry").add("tutorial", tutorialEntry)

-- TODO font registry
return Item {
  Text {
    x = 200, y = 100,
    color = rgba(0,0,255,0.5),
    text = "Hello World!",
    font_size = 60
  },
  Text {
    x = 200, y = 250,
    color = rgb(255,255,0),
    text = "Hello World!",
    scale = 3,
    font = {
      -- example image font from: https://www.love2d.org/wiki/Tutorial:Fonts_and_Text
      family = "tutorial", minFilter = "nearest", magFilter = "nearest"
    }
  },
}
