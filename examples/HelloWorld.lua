local rgb, rgba = require "util.rgb" ()

local Item = require "components.Item"
local Text = require "components.Text"
local ImageFontText = require "components.ImageFontText"

-- TODO font registry
return Item {
  Text {
    x = 200, y = 100,
    color = rgba(0,0,255,0.5),
    text = "Hello World!",
    font_size = 60
  },
  ImageFontText {
    x = 200, y = 250,
    color = rgb(255,255,0),
    text = "Hello World!",
    scale = 3,
    font = {
      src = "imagefont.png",
      -- example image font from: https://www.love2d.org/wiki/Tutorial:Fonts_and_Text
      glyphs = " " .. ImageFontText.aAd .. ".,!?-+/():;%&`'*#=[]\"",
      minFilter = "nearest", magFilter = "nearest"
    }
  },
}
