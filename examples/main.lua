package.path = "?;?.lua;?/init.lua;../src/?;../src/?.lua;../src/?/init.lua"
local examples = {}
examples.h = require "HelloWorld"
examples.r = require "Rectangles"

local currentExample = "h"

local helpFont, textWidth
local text = "Press to switch: [H] Hello World  [R] Rectangles"

function love.load()
  helpFont = love.graphics.newFont(12)
  textWidth = helpFont:getWidth(text)
  love.graphics.setBackgroundColor(255, 255, 255)
end


function love.draw()
  examples[currentExample]:draw()
  love.graphics.setColor(0, 0, 0, 50)
  love.graphics.rectangle("fill", 0, 0, textWidth + 10, helpFont:getHeight() + 4)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(text, 5, 2)
end

function love.textinput(t)
  if examples[t] then
    currentExample = t
  end
end
