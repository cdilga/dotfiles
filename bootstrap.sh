#!/bin/bash
# New-machine setup:
#   git clone https://github.com/cdilga/dotfiles ~/Documents/dev/dotfiles && ~/Documents/dev/dotfiles/bootstrap.sh
# Requires Homebrew already installed (https://brew.sh).
set -euo pipefail
cd "$(dirname "$0")"

command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
brew bundle --file=Brewfile

for pkg in zsh git wezterm karabiner yabai; do
  stow --no-folding -v -t "$HOME" "$pkg"
done

./macos/defaults.sh

cat <<'MSG'

Manual steps (macOS will not let scripts do these):
 1. System Settings > Privacy: grant Accessibility to yabai, Karabiner, noswoosh, Asyar;
    Input Monitoring to Karabiner. Then: yabai --start-service ; noswoosh setup
 2. Mission Control: create Spaces up to 9.
 3. Asyar: set its global hotkey to Ctrl+Opt+Cmd+Space (Karabiner maps Cmd+Space and Super+Space to it).
 4. Create untracked machine files: ~/.zshrc.local (secrets), ~/.gitconfig.local, ~/.wezterm.local.lua
MSG
