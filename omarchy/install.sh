#!/usr/bin/env bash
# Omarchy side of the shared dotfiles. Idempotent: symlinks each file into $HOME (backing up any
# real file it replaces to <file>.pre-dotfiles), hooks the shared keymap into hypr/bindings.lua,
# then reloads Hyprland, voxtype and Solaar.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

for pkg in hypr solaar voxtype bin; do
  (cd "$here/$pkg" && find . -type f) | while read -r rel; do
    rel="${rel#./}"; src="$here/$pkg/$rel"; dst="$HOME/$rel"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then mv "$dst" "$dst.pre-dotfiles"; fi
    ln -sfn "$src" "$dst"
    echo "linked $dst"
  done
done

bindings="$HOME/.config/hypr/bindings.lua"
grep -q 'require("hypr.shared_bindings")' "$bindings" 2>/dev/null ||
  printf '\n-- Shared Mac/Omarchy keymap (dotfiles/omarchy/hypr)\nrequire("hypr.shared_bindings")\n' >> "$bindings"

hyprctl reload >/dev/null && hyprctl configerrors
systemctl --user daemon-reload
systemctl --user restart voxtype
pkill -x solaar 2>/dev/null || pkill -f '/usr/bin/solaar' || true
setsid solaar -w hide >/dev/null 2>&1 < /dev/null &
echo "Done. Check: voxtype info accel; hyprctl configerrors"
