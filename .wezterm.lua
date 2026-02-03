local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================================================
-- FONTS
-- ============================================================================
config.font = wezterm.font('MesloLGS NF')
config.font_size = 14.0

-- Fallback fonts for symbols/emoji
config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font('MesloLGS NF', { weight = 'Bold' }),
  },
  {
    italic = true,
    font = wezterm.font('MesloLGS NF', { style = 'Italic' }),
  },
}

-- ============================================================================
-- APPEARANCE
-- ============================================================================
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- ============================================================================
-- KEYBINDINGS - Word Navigation & Deletion
-- ============================================================================
-- Make Option key act as Alt for word movement
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.keys = {
  -- Option+Left: Move word backward
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'b', mods = 'ALT' },
  },
  -- Option+Right: Move word forward
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'f', mods = 'ALT' },
  },
  -- Option+Backspace: Delete word backward
  {
    key = 'Backspace',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
  },
  -- Cmd+Left: Go to beginning of line
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
  -- Cmd+Right: Go to end of line
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'e', mods = 'CTRL' },
  },
  -- Cmd+Backspace: Delete to beginning of line
  {
    key = 'Backspace',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'u', mods = 'CTRL' },
  },
  -- Cmd+Delete: Delete to end of line (Ctrl+K)
  {
    key = 'Delete',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'k', mods = 'CTRL' },
  },
}

-- ============================================================================
-- PERFORMANCE
-- ============================================================================
config.front_end = "WebGpu"
config.max_fps = 120

return config
