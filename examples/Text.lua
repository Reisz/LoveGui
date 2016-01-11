local rgb = require "util.rgb" ()

local Item = require "components.Item"
local Text = require "components.Text"
local Column = require "components.Column"

return Column {
  x = 150, y = 50, spacing = 10,
  Text {
    width = 600,
    color = rgb(255,0,0),
    text = [[
      Grumpy wizards make toxic brew for the evil Queen and Jack.
      GRUMPY WIZARDS MAKE TOXIC BREW FOR THE EVIL QUEEN AND JACK.
      The quick brown fox jumps over the lazy dog.
      THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
      Franz jagt im komplett verwahrlosten Taxi quer durch Bayern!
      FRANZ JAGT IM KOMPLETT VERWAHRLOSTEN TAXI QUER DURCH BAYERN!
      Welch fieser Katzentyp quält da süße Vögel bloß zum Jux?
      WELCH FIESER KATZENTYP QUÄLT DA SÜSSE VÖGEL BLOß ZUM JUX?
      Asynchrone Bassklänge vom Jazzquintett sind nix für spießige Löwen.
      Dès Noël où un zéphyr haï me vêt de glaçons würmiens,
      je dîne d'exquis rôtis de bœuf au kir à l'aÿ d'âge mûr & cætera!
      DÈS NOËL OÙ UN ZÉPHYR HAÏ ME VÊT DE GLAÇONS WÜRMIENS,
      JE DÎNE D'EXQUIS RÔTIS DE BŒUF AU KIR À L'AŸ D'ÂGE MÛR & CÆTERA!
    ]],
    font_family = "if1", font_size = 18
  },
  Text {
    width = 600,
    color = rgb(0,177,177),
    text = [=[
      ```lua
        local x = 20 + [19 * 37! - (46 / 58)
        if 0 < 1 and 2 > 1 then print("`^^´") end
        local string1 = "fish|efficient|afflict|affect|fern"
        local string_test = [[haft]]
        local table = {
          ["temp"] = '34.23°C', ["price"] = '$51.34',
          ["pi"] = '~3.14', ["progress"] = '10.23%',
          ["email"] = 'mail@example.com',
          ["www"] = 'http://test.example.com/demopage.html'
        }
        print(#string1, string1)
        print(string.sub(string1, 2, 3))
      ```
    ]=],
    font = { family = "if1", size = 14 }
  }
}
