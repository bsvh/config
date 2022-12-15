local wezterm = require 'wezterm'
local host_settings = require 'host_settings'
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

return {
  window_decorations = 'RESIZE',
  term = 'wezterm',
  enable_wayland = true,
  color_scheme = "Molokai",
  font = wezterm.font {
    family = 'Iosevka Term',
    harfbuzz_features = { "ss09", "calt" },
  },
  font_size = 11,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  colors = {
    background = "#222222",
  },
}

