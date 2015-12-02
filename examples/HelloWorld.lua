local Item = require "components.Item"
local Text = require "components.Text"

return Item {
  Text {
    x = 300, y = 200,
    color = {0,0,255},
    text = "Hello World!",
    font_size = 35
  },
  Text {
    x = 315, y = 350,
    color = {0,0,255},
    text = "Hello World!",
    font = {
      size = 35,
      data = "imagefont.png",
      imageFontGlyphs = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\""
    }
  }
}
