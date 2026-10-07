#!/bin/bash
# New-machine setup (macOS or Omarchy):
#   git clone https://github.com/cdilga/dotfiles ~/dotfiles && ~/dotfiles/bootstrap.sh
set -euo pipefail
cd "$(dirname "$0")"

# Secret scan on every commit, on every machine (fails closed without gitleaks).
git config core.hooksPath .githooks

if [ "$(uname)" = "Linux" ]; then
  command -v gitleaks >/dev/null || echo "Install gitleaks for the commit hook: sudo pacman -S gitleaks"
  exec ./omarchy/install.sh
fi

# --- macOS ---
command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
brew bundle --file=Brewfile

for pkg in zsh git wezterm aerospace; do
  stow --no-folding -v -t "$HOME" "$pkg"
done

./karabiner/install.sh   # copied, not stowed: Karabiner rewrites its own config file
./mx-gesture/install.sh  # MX Master gesture button: push-to-talk (F18) + swipes
./macos/defaults.sh
open -a AeroSpace

cat <<'MSG'

Manual steps (macOS will not let scripts do these):
 1. System Settings > Privacy & Security:
      Accessibility:     AeroSpace, Karabiner, Asyar, SwipeAeroSpace, ~/.local/bin/mx-gesture
      Input Monitoring:  Karabiner, ~/.local/bin/mx-gesture
 2. Asyar: set its global hotkey to Cmd+Space (Karabiner's Super+Space emits it).
 3. Dictation app (Wispr Flow / Handy / ...): set push-to-talk (hold) to F18. The MX gesture button sends it.
 4. Create untracked machine files: ~/.zshrc.local (secrets), ~/.gitconfig.local, ~/.wezterm.local.lua,
    optionally ~/.config/mx-gesture/action.local (e.g. a different browser at work).
 5. Mission Control: delete every Space but one (AeroSpace workspaces replace them).
 6. Log out and back in once (Spaces + shortcut changes).
MSG
