#!/bin/bash
# Karabiner rewrites ~/.config/karabiner/karabiner.json (and replaces symlinks), so this
# package is COPIED, not stowed. Edit the repo copy, then run this to deploy; Karabiner auto-reloads.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)/.config/karabiner/karabiner.json"
dst="$HOME/.config/karabiner/karabiner.json"
mkdir -p "$(dirname "$dst")"
[ -L "$dst" ] && rm "$dst"
cp "$src" "$dst"
echo "Installed $dst"
