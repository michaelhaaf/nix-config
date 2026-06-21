{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
      local act = wezterm.action

      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.hide_tab_bar_if_only_one_tab = true
      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = false

      config.window_background_opacity = 0.80

      config.term = 'wezterm'
      config.window_padding = { left = 24, right = 24, top = 24, bottom = 24, }
      config.animation_fps = 1
      config.cursor_blink_ease_in = 'Constant'
      config.cursor_blink_ease_out = 'Constant'
      config.font_size = 15.0
      config.adjust_window_size_when_changing_font_size = false

      config.keys = {
        { key = 'd', mods = 'ALT', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
        { key = 'r', mods = 'ALT', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
        { key = 'd', mods = 'SHIFT|CTRL', action = act.ScrollByPage(0.5) },
        { key = 'u', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-0.5) },
        {
          -- search for things that look like git hashes
          -- see https://wezterm.org/scrollback.html#configuring-saved-searches
          key = 'H',
          mods = 'SHIFT|CTRL',
          action = wezterm.action.Search { Regex = '[a-f0-9]{6,}' },
        },
      }

      smart_splits.apply_to_config(config, {
        -- modifier keys to combine with direction_keys
        modifiers = {
          move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
          resize = 'ALT', -- modifier to use for pane resize, e.g. ALT+h to resize to the left
        },
      })

      return config
    '';
  };
}
