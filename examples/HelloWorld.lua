local rgb, rgba = require "util.rgb" ()

local Item = require "components.Item"
local Text = require "components.Text"
local ImageFontText = require "components.ImageFontText"

return Item {
  Text {
    x = 300, y = 200,
    color = rgba(0,0,255,0.5),
    text = "Hello World!",
    font_size = 35
  },
  ImageFontText {
    x = 340, y = 350,
    color = rgb(0,0,255),
    text = "Hello World!",
    font = {
      src = "imagefont.png",
      -- example image font from: https://www.love2d.org/wiki/Tutorial:Fonts_and_Text
      glyphs = " " .. ImageFontText.aAd .. ".,!?-+/():;%&`'*#=[]\""
    }
  }
}
