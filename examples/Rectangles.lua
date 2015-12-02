local rgb = require "util.rgb" ()
local Item = require "components.Item"
local Rectangle = require "components.Rectangle"

return Item {
  Item {
    x = 150, y = 150,
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      color = rgb(0,0,255)
    },
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = rgb(255,0,0)
    },
  },
  Item {
    x = 450, y = 150,
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = rgb(255,0,0),
      border = {
        width = 2,
        color = rgb(75,0,0)
      }
    },
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      color = rgb(0,0,255),
      border_width = 2,
      border_color = rgb(0,0,75)
    },
  },
  Item {
    x = 150, y = 350,
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      color = rgb(0,0,255),
      radius = 10
    },
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = rgb(255,0,0),
      radius = 10,
      radiusSegments = 1
    },
  },
  Item {
    x = 450, y = 350,
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = rgb(255,0,0),
      border = {
        width = 2,
        color = rgb(75,0,0)
      },
      radius = 10,
      radiusSegments = 1
    },
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      color = rgb(0,0,255),
      border_width = 2,
      border_color = rgb(0,0,75),
      radius = 10
    },
  },
}
