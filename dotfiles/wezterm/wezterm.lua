local wezterm = require 'wezterm'
local act = wezterm.action
local host_settings = require 'host_settings'
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

return {
  set_environment_variables = host_settings.set_environment_variables,
  window_decorations = 'RESIZE',
  term = 'wezterm',
  enable_wayland = true,
  color_scheme = "Molokai",
  font = wezterm.font {
    --family = 'Iosevka Term',
    family = 'Hack FC Ligatured',
    --harfbuzz_features = { "ss09", "calt" },
    harfbuzz_features = { "calt" }
    
  },
  font_size = 10,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  colors = {
    background = "#222222",
  },
  keys = {
    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
  },
  mouse_bindings = {
    {
      event = { Down = { streak = 3, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },
  },
}

