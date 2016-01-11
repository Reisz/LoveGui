if Font then
  Font("if1"):add {
    type = "utf8", file = "Image Font 1.png",
    glyphs =
      Font.glyphs.saAd ..
      ".,!?-+/\\_~():;%&`´'*#=[]\"{}$<>|^°@€§" ..
      "àáâäæçèéêëìíîïòóôöœßùúûüÿÀÁÂÄÆÇÈÉÊËÌÍÎÏÒÓÔÖŒÙÚÛÜŸ" ..
      Font.glyphs.u8,
    autolig = {"ffi", "fft", "ffl", "ff", "fi", "ft", "fl", "tt"},
    autokern = {
      "f" .. Font.glyphs.u_4, "acdefgijmnopqrstuvwxyzàáâäæçèéêëìíîïòóôöœßùúûüÿ", -1,
      "t", "ftvwz" .. Font.glyphs.u_8, -1,
      "r", "o", -1,
      "l", "ft" .. Font.glyphs.u8, -1,
      "abcdefhiklmnoprstuvwxz" .. Font.glyphs.u8, "j", -3
    }, size = 18, baseline = 13, ascent = 12, descent = 4, weight = 50, italic = false,
    minFilter = "linear", magFilter = "nearest", anisotropy = 16
  }
end
