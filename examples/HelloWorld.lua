local rgb, rgba = require "util.rgb" ()

local Column = require "components.Column"
local Text = require "components.Text"

return Column {
  x = 100, y = 100, spacing = 30,
  Text {
    width = 600, horizontalAlignment = "center",
    color = rgba(0,0,255,0.5),
    text = "Hello World!",
    font_size = 60
  },
  Text {
    width = 600, horizontalAlignment = "center",
    color = rgb(0,0,255),
    text = "Hello World!",
    font_family = "lobster", font_size = 60
  },
  Text {
    width = 600, horizontalAlignment = "center",
    color = rgb(255,255,0),
    text = "Hello World!",
    font_family = "tutorial", font_size = 60
  },
  Text {
    width = 600, horizontalAlignment = "center",
    color = rgb(141,193,13),
    text = "Hello World!",
    font_family = "if1", font_size = 60
  },
}
