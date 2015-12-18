package.path = "?.lua;?/init.lua;../src/?.lua;../src/?/init.lua"
local examples = { ["h"] = 1, ["t"] = 2, ["r"] = 3}

local Item = require "components.Item"
local Rectangle = require "components.Rectangle"
local Text = require "components.Text"
local Swap = require "components.Swap"

local item = Item {
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

function love.load()
  love.graphics.setBackgroundColor(255, 255, 255)
end


function love.draw()
  item:draw()
end

function love.textinput(t)
  if examples[t] then
    item.children[2].index = examples[t]
  end
end
