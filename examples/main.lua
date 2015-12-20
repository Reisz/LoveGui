package.path = "?.lua;?/init.lua;../src/?.lua;../src/?/init.lua"
local examples = { ["h"] = 1, ["t"] = 2, ["r"] = 3}

local MainItem = require "components.MainItem"
local Rectangle = require "components.Rectangle"
local Text = require "components.Text"
local Swap = require "components.Swap"

--- TODO simplify, maybe load a folder "fonts"
local FontEntry = require "util.Font.Entry"
local FontObject = require "util.Font.Object"
local tutorialEntry = FontEntry()
-- example image font from: https://www.love2d.org/wiki/Tutorial:Fonts_and_Text
local tutorial = love.graphics.newImageFont("imagefont.png", FontObject.glyphs.saAd .. ".,!?-+/():;%&`'*#=[]\"")
tutorialEntry:addVariant(FontObject(tutorial, 17), 50, false);
(require "util.Font.Registry").add("tutorial", tutorialEntry)
local if1Entry = FontEntry()
local if1 = love.graphics.newImageFont("Image Font 1.png", FontObject.glyphs.saAd .. ".,!?-+/\\_~():;%&`´'*#=[]\"{}$<>|^°@äöüÄÖÜß")
if1:setFilter("linear", "nearest")
if1Entry:addVariant(FontObject(if1, 18), 50, false);
(require "util.Font.Registry").add("if1", if1Entry)

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
