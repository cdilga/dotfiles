#!/bin/bash
# Idempotent macOS settings for the WM stack. Safe to re-run.
set -euo pipefail

PL=~/Library/Preferences/com.apple.symbolichotkeys.plist

# Deterministic Spaces: no MRU reordering, one Space set per display
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.spaces spans-displays -bool false

# set_hk <id> <enabled:true|false> <param1> <keycode> <modifier-mask>
set_hk() {
  /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:$1" "$PL" 2>/dev/null || true
  /usr/libexec/PlistBuddy \
    -c "Add :AppleSymbolicHotKeys:$1 dict" \
    -c "Add :AppleSymbolicHotKeys:$1:enabled bool $2" \
    -c "Add :AppleSymbolicHotKeys:$1:value dict" \
    -c "Add :AppleSymbolicHotKeys:$1:value:type string standard" \
    -c "Add :AppleSymbolicHotKeys:$1:value:parameters array" \
    -c "Add :AppleSymbolicHotKeys:$1:value:parameters: integer $3" \
    -c "Add :AppleSymbolicHotKeys:$1:value:parameters: integer $4" \
    -c "Add :AppleSymbolicHotKeys:$1:value:parameters: integer $5" \
    "$PL"
}

# Mission Control "Switch to Desktop N" = Ctrl+N (hotkeys 118..126; keycodes for 1..9)
i=118
for kc in 18 19 20 21 23 22 26 28 25; do
  set_hk "$i" true 65535 "$kc" 262144
  i=$((i + 1))
done

# Spotlight UI -> Option+Space (frees Cmd+Space for Asyar); Finder-search shortcut off
set_hk 64 true 32 49 524288
set_hk 65 false 32 49 1572864

# ChatGPT's "Show mini" launcher is hard-wired to Option+Space with no UI to clear it.
# Move it to an unused chord (Ctrl+Opt+Cmd+Shift+F19). Takes effect on next ChatGPT launch.
defaults write com.openai.chat KeyboardShortcuts_toggleLauncher -string '{"carbonKeyCode":80,"carbonModifiers":7168}'

killall Dock cfprefsd 2>/dev/null || true
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u || true
echo "Done. Manual: create Spaces up to 9 in Mission Control; log out/in if shortcuts don't apply."
