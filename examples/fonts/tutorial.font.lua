if Font then
  -- example image font from: https://www.love2d.org/wiki/Tutorial:Fonts_and_Text
  Font("tutorial"):add {
    type = "image", file = "fonts/imagefont.png",
    glyphs = Font.glyphs.saAd .. ".,!?-+/():;%&`'*#=[]\"",
    size = 17, weight = 50, italic = false, magFilter = "nearest"
  }
end
