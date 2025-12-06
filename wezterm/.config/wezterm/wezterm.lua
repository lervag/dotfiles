-- Referanser
-- * ~/.local/wiki/wezterm.wiki
-- * https://wezfurlong.org/wezterm/config/lua/config/index.html

local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font "JuliaMono"
config.font_size = 13.5
config.initial_rows = 46
config.initial_cols = 82
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.use_resize_increments = true
config.max_fps = 120

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
  -- Source:
  -- https://github.com/wezterm/wezterm/issues/222#issuecomment-706444410
  local io = require "io"
  local os = require "os"

  local scrollback = pane:get_lines_as_text()

  local name = os.tmpname()
  local f = io.open(name, "w+")
  f:write(scrollback)
  f:flush()
  f:close()

  window:perform_action(
    wezterm.action { SpawnCommandInNewWindow = { args = { "nvim", name } } },
    pane
  )

  wezterm.sleep_ms(1000)
  os.remove(name)
end)

config.keys = {
  {
    key = "E",
    mods = "SHIFT|CTRL",
    action = wezterm.action { EmitEvent = "trigger-vim-with-scrollback" },
  },
  {
    key = "w",
    mods = "SUPER",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "-",
    mods = "SUPER",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "-",
    mods = "SHIFT|CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "_",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "_",
    mods = "SHIFT|CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = "Left" } },
    action = wezterm.action.SelectTextAtMouseCursor "SemanticZone",
  },
}

config.colors = {
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
}

return config
