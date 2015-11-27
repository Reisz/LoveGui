local Item = require "components.Item"
local Text = require "components.Text"

return Item {
  Text {
    x = 350, y = 300,
    color = {0,0,255},
    text = "Hello World!"
  }
}
