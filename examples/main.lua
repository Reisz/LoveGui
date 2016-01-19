package.path = "?.lua;?/init.lua;../src/?.lua;../src/?/init.lua"
local examples = { ["h"] = 1, ["t"] = 2, ["r"] = 3}

local MainItem = require "components.MainItem"
local Rectangle = require "components.Rectangle"
local Text = require "components.Text"
local Swap = require "components.Swap"

local FontEntry = require "util.Font.Entry"
-- Lobster from http://google.com/fonts
FontEntry("lobster"):add {
  type = "data", file = "fonts/Lobster-Regular.ttf",
  weight = 50, italic = false
}
FontEntry.load("fonts")

local item = MainItem {
  background = {255, 255, 255},
  Rectangle {
    width = 500, height = 16,
    color = {0, 0, 0, 50},
    Text {
      text = "Press to switch: [H] Hello World  [T] Text  [R] Rectangles",
    }
  },
  Swap {
    (require "HelloWorld"),
    (require "Text"),
    (require "Rectangles")
  }
}

function love.textinput(t)
  if examples[t] then
    item.children[2].index = examples[t]
  end
end
