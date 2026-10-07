# dotfiles

macOS and Omarchy dev environment, laid out as one [GNU Stow](https://www.gnu.org/software/stow/) package per tool. Each directory mirrors `$HOME`.

```
zsh/        .zshrc, .p10k.zsh
git/        .gitconfig
wezterm/    .wezterm.lua
aerospace/  .config/aerospace/aerospace.toml    tiling WM (macOS)
karabiner/  karabiner.json + install.sh (copied, not stowed: Karabiner rewrites symlinks)
mx-gesture/ MX Master gesture-button daemon (macOS) + install.sh
macos/      defaults.sh                         Spaces + Spotlight shortcuts
omarchy/    hypr, solaar, voxtype, bin + install.sh   (Omarchy/Hyprland side)
KEYMAP.md   the one keymap both platforms follow
Brewfile    everything installed via Homebrew
bootstrap.sh  macOS or Omarchy, detected
```

## New machine

```bash
git clone https://github.com/cdilga/dotfiles ~/dotfiles
~/dotfiles/bootstrap.sh
```

On macOS `bootstrap.sh` installs the Brewfile, stows the packages, builds `mx-gesture` and runs `macos/defaults.sh`. On Omarchy it runs `omarchy/install.sh`, which symlinks the Omarchy packages. Either way it turns on the gitleaks pre-commit hook. macOS does not let scripts grant Accessibility or Input Monitoring, so it prints the remaining manual steps.

## Machine-specific and secret config (never committed)

This repo is public. Tracked files source these optional, untracked files:

| File | For |
|---|---|
| `~/.zshrc.local` | tokens, private paths |
| `~/.gitconfig.local` | LAN credential helpers |
| `~/.wezterm.local.lua` | returns `function(config) ... end`, e.g. SSH domains |

## Window-management stack

Keyboard-first and the same as Omarchy: see [KEYMAP.md](KEYMAP.md). SIP stays **on**.

- **AeroSpace**: tiling and its own virtual workspaces, so moving a window to workspace N works without the yabai scripting addition. It owns every `Super` binding.
- **Karabiner-Elements**: **Caps Lock** is **Super**: Ctrl+Opt+Cmd while held, Esc on tap. The rest is `Super+Space` (Cmd+Space, Asyar) and `Super+V` (Cmd+V).
- **mx-gesture**: re-diverts the MX Master gesture button over HID++ whenever the mouse connects (Options+ is not needed). Hold sends F18 for push-to-talk dictation, and swipes run `~/.config/mx-gesture/action`. It matches the Solaar rules on Omarchy.
- **SwipeAeroSpace**: three-finger horizontal trackpad swipe switches AeroSpace workspaces. `macos/defaults.sh` takes that gesture away from macOS and frees Ctrl+←/→ for apps.
- **One native Space**: AeroSpace workspaces replace macOS Spaces, so keep a single Space in Mission Control. Then every window is AeroSpace's and switches are instant without noswoosh.
- **Asyar**: launcher, hotkey `Cmd+Space`. Apple Spotlight moves to `Option+Space`.

yabai, skhd and noswoosh were dropped (October 2026) in favour of AeroSpace.

`macos/defaults.sh` also moves ChatGPT's "Show mini" shortcut off `Option+Space`. The app has no UI to clear it.

## Secrets

The repo is public. `.githooks/pre-commit` runs gitleaks (defaults + `.gitleaks.toml`) on staged changes and refuses to commit if gitleaks is missing. `.github/workflows/gitleaks.yml` scans the full history on every push, for commits that skipped the hook.

## Shell

- Lazy-loaded nvm/pyenv, git aliases, zsh-autosuggestions, history substring search, fzf, zoxide, Powerlevel10k.
- WezTerm: Catppuccin Mocha, MesloLGS NF, WebGPU at 120fps, macOS-style Opt/Cmd cursor movement.

## Theme sync with Omarchy

Planned: one palette file that generates WezTerm colours here. Omarchy gets its own generated output, so the two sides share the palette but not the tools.
