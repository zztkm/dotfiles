-- This table will hold the configuration.
local config = wezterm.config_builder()

--config.color_scheme = 'GitHub Dark'
config.color_scheme = 'Catppuccin Macchiato'

config.font = wezterm.font('Cica', { weight = 'Regular' })
config.font_size = 15

config.use_ime = true

config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  {
    key = 'd',
    mods = 'SHIFT|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Right',
      size = { Percent = 50 },
    },
  },
  {
    key = '1',
    mods = 'ALT',
	action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|TABS' },
  },
  {
    key = '1',
    mods = 'CTRL',
	action = wezterm.action.PaneSelect,
  }
}

return config
