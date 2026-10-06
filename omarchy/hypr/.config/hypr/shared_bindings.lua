-- Shared keymap (see KEYMAP.md in the dotfiles repo). Loaded from ~/.config/hypr/bindings.lua with
--   require("hypr.shared_bindings")
-- Keep in step with aerospace/.config/aerospace/aerospace.toml on macOS.

-- Caps Lock is Super. Compose moves to Right Alt; both Shifts together still toggle Caps Lock.
hl.config({ input = { kb_options = "compose:ralt,caps:super,shift:both_capslock" } })

-- Free hjkl from Omarchy defaults, then re-home what they did.
hl.unbind("SUPER + H")
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
o.bind("SUPER + E", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + A", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + F1", "Keybindings", "omarchy-menu-keybindings")

-- Focus: Super + hjkl (arrows stay as Omarchy defines them)
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Swap: Super + Shift + hjkl
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
