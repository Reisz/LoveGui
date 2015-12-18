local rgb = require "util.rgb" ()

local Item = require "components.Item"
local Text = require "components.Text"

--- TODO simplify, maybe load a folder "fonts"
local FontEntry = require "util.Font.Entry"
local FontObject = require "util.Font.Object"
local if1Entry = FontEntry()
if1Entry:addVariant(
  FontObject(love.graphics.newImageFont("Image Font 1.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/\\_~():;%&`´'*#=[]\"{}$<>|^°@äöüÄÖÜß")),
  17, 50, false);
(require "util.Font.Registry").add("if1", if1Entry)


return Item {
  Text {
    x = 180, y = 50,
    color = rgb(255,0,0),
    text = [[
      Grumpy wizards make toxic brew for the evil Queen and Jack.
      THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
      Franz jagt im komplett verwahrlosten Taxi quer durch Bayern!
      WELCH FIESER KATZENTYP QUÄLT DA SÜSSE VÖGEL BLOß ZUM JUX?
      Asynchrone Bassklänge vom Jazzquintett sind nix für spießige Löwen.
    ]],
    font_family = "if1"
  },
  Text {
    x = 150, y = 180,
    color = rgb(177,0,177),
    scale = 3,
    text = "x = 20 + [19 * 37! - (46 / 58)]",
    font = {
      family = "if1", minFilter = "nearest", magFilter = "nearest"
    }
  },
  Text {
    x = 200, y = 270,
    color = rgb(0,177,177),
    text = [=[
      ```lua
        if 0 < 1 and 2 > 1 then print("`^^´") end
        local string1 = "|efficient|"
        local string_test = [[haft]]
        local table = {
          ["temp"] = '34.23°C',
          ["price"] = '$51.34',
          ["pi"] = '~3.14',
          ["progress"] = '10.23%',
          ["email"] = 'mail@example.com',
          ["www"] = 'http://test.example.com/demopage.html'
        }
        print(#string1, string1)
        print(string.sub(string1, 2, 3))
      ```
    ]=],
    font = {
      family = "if1", minFilter = "nearest", magFilter = "nearest"
    }
  }
}
