local rgb = require "util.rgb" ()

local Item = require "components.Item"
local ImageFontText = require "components.ImageFontText"

local if1glyphs = " " .. ImageFontText.aAd .. ".,!?-+/\\_~():;%&`´'*#=[]\"{}$<>|^°@äöüÄÖÜß"

return Item {
  ImageFontText {
    x = 180, y = 50,
    color = rgb(255,0,0),
    text = [[
      Grumpy wizards make toxic brew for the evil Queen and Jack.
      THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
      Franz jagt im komplett verwahrlosten Taxi quer durch Bayern!
      WELCH FIESER KATZENTYP QUÄLT DA SÜSSE VÖGEL BLOß ZUM JUX?
      Asynchrone Bassklänge vom Jazzquintett sind nix für spießige Löwen.
    ]],
    font = {
      src = "Image Font 1.png",
      glyphs = if1glyphs
    }
  },
  ImageFontText {
    x = 150, y = 180,
    color = rgb(177,0,177),
    scale = 3,
    text = "x = 20 + [19 * 37! - (46 / 58)]",
    font = {
      src = "Image Font 1.png",
      glyphs = if1glyphs,
      minFilter = "nearest", magFilter = "nearest"
    }
  },
  ImageFontText {
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
      src = "Image Font 1.png",
      glyphs = if1glyphs,
      minFilter = "nearest", magFilter = "nearest"
    }
  }
}
