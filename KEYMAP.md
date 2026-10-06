# Shared keymap: macOS (AeroSpace) and Omarchy (Hyprland)

One set of muscle memory on both. **Super = Caps Lock** on every keyboard, including the laptop.

- macOS: Karabiner turns held Caps Lock into Ctrl+Opt+Cmd (tap = Esc). AeroSpace binds `ctrl-alt-cmd-…`.
- Omarchy: `caps:super` (xkb). Compose moved to Right Alt; press both Shifts for real Caps Lock.

Sources of truth: `aerospace/.config/aerospace/aerospace.toml` and `omarchy/hypr/.config/hypr/shared_bindings.lua`.
Everything else on Omarchy is its stock default (`Super+K`'s old menu is now `Super+F1`).

| Keys | Action | Notes |
|---|---|---|
| Super + H/J/K/L or arrows | Focus window left/down/up/right | |
| Super + Shift + H/J/K/L or arrows | Swap/move window | |
| Super + 1..9 | Go to workspace N | |
| Super + Shift + 1..9 | Move window to workspace N (and follow) | |
| Super + Tab / Super + Shift + Tab | Next / previous workspace | |
| Super + W | Close window | |
| Super + F | Fullscreen | |
| Super + T | Toggle floating | |
| Super + E | Toggle split direction | Omarchy default was Super+J |
| Super + A | Toggle workspace layout (tiles/accordion on Mac, Omarchy layout toggle) | Omarchy default was Super+L |
| Super + − / = | Resize | |
| Super + Enter | Terminal | |
| Super + Shift + Enter | Browser | |
| Super + Space | Launcher (Asyar / Omarchy menu) | |
| Super + V | Paste | Omarchy universal paste; Cmd+V on Mac |

Omarchy-only: everything on `Super+Alt+…` and `Super+Ctrl+…`. On macOS, Alt and Ctrl are already part of
Super, so those combos cannot be told apart and have no twin.

## MX Master 3S gesture button (both machines)

| Gesture | Action |
|---|---|
| Hold, talk, release | Dictation. Text streams while you talk. |
| Hold + swipe right / left | Next / previous workspace |
| Hold + swipe up | Browser (focus, or launch) |
| Hold + swipe down | Terminal (focus, or launch) |

- Omarchy: Solaar rules (`omarchy/solaar`) drive voxtype (`record start` / `stop` / `cancel`). Recording starts on press and a swipe discards it.
- macOS: `mx-gesture` (this repo) sends F18 down/up for dictation and runs `~/.config/mx-gesture/action` for swipes.
  Point the dictation app's push-to-talk (hold) key at F18.
