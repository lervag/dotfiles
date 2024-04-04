function conky_workspace()
  local w = {
    "⚫ ",
    "⚫ ",
    "⚫ ",
    "⚫",
  }

  local desktop = tonumber(conky_parse "$desktop")
  if desktop ~= nil and desktop >= 1 and desktop <= 4 then
    w[desktop] = "${color1}" .. w[desktop] .. "${color}"
  end

  return conky_parse("$font2$alignr" .. table.concat(w) .. "$font")
end
