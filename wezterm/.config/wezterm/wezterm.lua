local wezterm = require "wezterm"

return {
  hide_tab_bar_if_only_one_tab = true,
  colors = {
    foreground = "#839496",
    background = "#002b36",

    selection_fg = "#002b36",
    selection_bg = "#839496",

    cursor_fg = "#002b36",
    cursor_border = "#839496",
    cursor_bg = "#839496",

    ansi = {
      "#073642",
      "#dc322f",
      "#859900",
      "#b58900",
      "#268bd2",
      "#d33682",
      "#2aa198",
      "#eee8d5",
    },
    brights = {
      "#002b36",
      "#cb4b16",
      "#586e75",
      "#657b83",
      "#839496",
      "#6c71c4",
      "#93a1a1",
      "#fdf6e3",
    },
  },
  font = wezterm.font "JuliaMono",
  font_size = 13.5,
  initial_rows = 46,
  initial_cols = 82,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  use_resize_increments = true,
}
