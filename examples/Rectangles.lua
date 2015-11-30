local Item = require "components.Item"
local Rectangle = require "components.Rectangle"

return Item {
  Item {
    x = 150, y = 200,
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      color = {0, 0, 255}
    },
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = {255, 0, 0}
    },
  },
  Item {
    x = 450, y = 200,
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = {255, 0, 0},
      border = {
        width = 1,
        color = {0, 0, 0}
      }
    },
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      color = {0, 0, 255}
    },
  },
}
