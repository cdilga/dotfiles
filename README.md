# dotfiles

macOS dev environment, laid out as one [GNU Stow](https://www.gnu.org/software/stow/) package per tool. Each directory mirrors `$HOME`.

```
zsh/        .zshrc, .p10k.zsh
git/        .gitconfig
wezterm/    .wezterm.lua
karabiner/  .config/karabiner/karabiner.json   Super key + all WM keybinds
yabai/      .config/yabai/yabairc
macos/      defaults.sh                         Spaces, Mission Control + Spotlight shortcuts
Brewfile    everything installed via Homebrew
bootstrap.sh
```

## New machine

```bash
git clone https://github.com/cdilga/dotfiles ~/dotfiles
~/dotfiles/bootstrap.sh
```

Clone to `~/dotfiles`, not under `~/Documents`: macOS privacy controls stop Karabiner reading a symlinked `karabiner.json` there.

`bootstrap.sh` installs the Brewfile, stows the packages and runs `macos/defaults.sh`. macOS does not let scripts grant Accessibility or Input Monitoring, so it prints the remaining manual steps.

## Machine-specific and secret config (never committed)

This repo is public. Tracked files source these optional, untracked files:

| File | For |
|---|---|
| `~/.zshrc.local` | tokens, private paths |
| `~/.gitconfig.local` | LAN credential helpers |
| `~/.wezterm.local.lua` | returns `function(config) ... end`, e.g. SSH domains |

## Window-management stack

Keyboard-first, Omarchy/Hyprland-like, SIP left **on**.

- **Karabiner-Elements**: **Caps Lock** is **Super** (remapped, so it never locks), held as a variable (not a synthetic modifier, so `Super+Shift+X` stays distinct from `Super+X`). Karabiner replaces skhd and runs `yabai -m` directly.
- **yabai**: tiling, focus and warp. Without the scripting addition it cannot switch Spaces or move windows between them.
- **noswoosh**: makes native Space switching near-instant. Karabiner sends the native `Ctrl+N` shortcuts.
- **Asyar**: launcher, hotkey `Cmd+Space`. `Super+Space` emits `Cmd+Space`. Apple Spotlight moves to `Option+Space`.
- **Push-to-talk**: Karabiner emits F18 down/up from `Super+V` and, once identified, the MX Master gesture button. The dictation engine that listens for F18 is still to be chosen. BetterTouchTool was dropped (paid).

| Keys | Action |
|---|---|
| Super+H/J/K/L | focus west/south/north/east |
| Super+Shift+H/J/K/L | warp window |
| Super+1..9 | switch to Desktop N |
| Super+F / Super+T | zoom-fullscreen / toggle float |
| Super+Tab / Super+Shift+Tab | next / previous Space |
| Super+Enter | WezTerm |
| Cmd+Space, Super+Space | Asyar |
| Option+Space | Apple Spotlight |

Not done yet: `Super+Shift+1..9` (move window to Space) needs the yabai scripting addition, which means changing SIP. Deferred until it is missed.

`macos/defaults.sh` also moves ChatGPT's "Show mini" shortcut off `Option+Space`. The app has no UI to clear it.

## Shell

- Lazy-loaded nvm/pyenv, git aliases, zsh-autosuggestions, history substring search, fzf, zoxide, Powerlevel10k.
- WezTerm: Catppuccin Mocha, MesloLGS NF, WebGPU at 120fps, macOS-style Opt/Cmd cursor movement.

## Theme sync with Omarchy

Planned: one palette file that generates WezTerm and yabai colours here. Omarchy gets its own generated output, so the two sides share the palette but not the tools.
