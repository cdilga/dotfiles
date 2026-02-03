# dotfiles

Personal configuration files for macOS development environment.

## Contents

- `.zshrc` - Zsh configuration with lazy-loading for nvm/pyenv/conda, git aliases, and shell enhancements
- `.p10k.zsh` - Powerlevel10k theme configuration
- `.wezterm.lua` - WezTerm terminal configuration with macOS-native keybindings
- `.gitconfig` - Git configuration

## Features

### Zsh
- Fast startup with lazy-loaded nvm, pyenv, and conda
- Git aliases (g, ga, gst, gco, etc.)
- zsh-autosuggestions with Tab to accept
- History substring search (Up/Down filters by current input)
- fzf integration (Ctrl+R for history, Ctrl+T for files)
- zoxide for smart directory jumping

### WezTerm
- Catppuccin Mocha theme
- MesloLGS NF font (Nerd Font)
- macOS-native cursor movement:
  - `Opt+Arrow` - word navigation
  - `Cmd+Arrow` - line start/end
  - `Opt+Backspace` - delete word
  - `Cmd+Backspace` - delete to line start
- WebGPU rendering at 120fps

## Installation

```bash
# Clone the repo
git clone https://github.com/cdilga/dotfiles.git ~/dotfiles

# Symlink configs (backup existing files first)
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.wezterm.lua ~/.wezterm.lua
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
```

## Dependencies

```bash
# Homebrew packages
brew install powerlevel10k zsh-autosuggestions zsh-history-substring-search fzf zoxide

# Fonts
brew install --cask font-meslo-lg-nerd-font
```
