local rgb, rgba = require "util.rgb" ()
local Item = require "components.Item"
local Rectangle = require "components.Rectangle"
local Gradient = require "components.Gradient"

return Item {
  Item {
    x = 150, y = 150,
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      gradient = Gradient {
        type = "horizontal",
        {pos = 0, color = rgba(0, 0, 255, 0.2)},
        {pos = 1, color = rgba(0, 0, 255, 0.8)},
      },
    },
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = rgb(255,0,0)
    },
  },
  Rectangle {
    x = 450, y = 150,
    width = 100, height = 100,
    gradient = Gradient {
      type = "radial",
      {pos = 0, color = rgb(177, 0, 177)},
      {pos = 0.8, color = rgb(0, 0, 255)},
    },
    border_width = 2,
    border_color = rgb(0,0,75),
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      gradient = Gradient {
        {pos = 0, color = rgb(90, 0, 0)},
        {pos = 1, color = rgb(255, 0, 0)},
      },
      border = {
        width = 2,
        color = rgb(75,0,0)
      },
    },
  },
  Item {
    x = 150, y = 350,
    Rectangle {
      x = 0, y = 0,
      width = 100, height = 100,
      gradient = Gradient {
        type = "horizontal",
        {pos = 0, color = rgba(0, 0, 255, 0.2)},
        {pos = 1, color = rgba(0, 0, 255, 0.8)},
      },
      radius = 10,
    },
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      color = rgb(255,0,0),
      radius = 10,
      radiusSegments = 1,
    },
  },
  Rectangle {
    x = 450, y = 350,
    width = 100, height = 100,
    gradient = Gradient {
      type = "radial",
      {pos = 0, color = rgb(177, 0, 177)},
      {pos = 0.8, color = rgb(0, 0, 255)},
    },
    border_width = 2,
    border_color = rgb(0,0,75),
    radius = 10,
    Rectangle {
      x = 50, y = 50,
      width = 100, height = 100,
      gradient = Gradient {
        {pos = 0, color = rgb(90, 0, 0)},
        {pos = 1, color = rgb(255, 0, 0)},
      },
      border = {
        width = 2,
        color = rgb(75,0,0)
      },
      radius = 10,
      radiusSegments = 1,
    },
  },
}
