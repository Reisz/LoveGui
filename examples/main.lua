package.path = "?.lua;?/init.lua;../src/?.lua;../src/?/init.lua"
local examples = { ["h"] = 1, ["t"] = 2, ["r"] = 3}

local MainItem = require "components.MainItem"
local Rectangle = require "components.Rectangle"
local Text = require "components.Text"
local Swap = require "components.Swap"
  
local FontEntry = require "util.Font.Entry"
-- example image font from: https://www.love2d.org/wiki/Tutorial:Fonts_and_Text
FontEntry("tutorial"):add {
  type = "image", file = "imagefont.png",
  glyphs = FontEntry.glyphs.saAd .. ".,!?-+/():;%&`'*#=[]\"",
  size = 17, weight = 50, italic = false, magFilter = "nearest"
}
-- Lobster from http://google.com/fonts
FontEntry("lobster"):add {
  type = "data", file = "Lobster-Regular.ttf",
  weight = 50, italic = false
}
FontEntry.load("fonts/if1.font.lua")

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
