#!/bin/bash
# Build mx-gesture, install it to ~/.local/bin and run it as a LaunchAgent. Safe to re-run.
# After the first install (and after every rebuild, since the binary's signature changes) macOS asks for:
#   Input Monitoring + Accessibility for ~/.local/bin/mx-gesture
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
bin="$HOME/.local/bin/mx-gesture"
label="dev.dilger.mx-gesture"
plist="$HOME/Library/LaunchAgents/$label.plist"

mkdir -p "$HOME/.local/bin" "$HOME/.config/mx-gesture" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
swiftc -O -o "$bin.new" "$here/src/main.swift"
codesign -f -s - -i "$label" "$bin.new"
mv -f "$bin.new" "$bin"
ln -sfn "$here/.config/mx-gesture/action" "$HOME/.config/mx-gesture/action"

cat >"$plist.new" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>$label</string>
  <key>ProgramArguments</key><array><string>$bin</string></array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>ProcessType</key><string>Interactive</string>
  <key>StandardErrorPath</key><string>$HOME/Library/Logs/mx-gesture.log</string>
</dict></plist>
EOF
mv -f "$plist.new" "$plist"

launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$plist"
echo "mx-gesture running. Log: ~/Library/Logs/mx-gesture.log"
