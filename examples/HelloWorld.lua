local rgb, rgba = require "util.rgb" ()

local Item = require "components.Item"
local Text = require "components.Text"

return Item {
  Text {
    x = 200, y = 100,
    color = rgba(0,0,255,0.5),
    text = "Hello World!",
    font_size = 60
  },
  Text {
    x = 150, y = 250,
    color = rgb(255,255,0),
    text = "Hello World!",
    font = {
      family = "tutorial", size = 60, minFilter = "nearest", magFilter = "nearest"
    }
  },
  Text {
    x = 230, y = 400,
    color = rgb(141,193,13),
    text = "Hello World!",
    font = {
      family = "if1", size = 60, minFilter = "nearest", magFilter = "nearest"
    }
  },
}
