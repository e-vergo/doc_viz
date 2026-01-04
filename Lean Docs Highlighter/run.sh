#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_PATH="$SCRIPT_DIR/build/Build/Products/Debug/Lean Docs Highlighter.app"

if [ ! -d "$APP_PATH" ]; then
    echo "App not found. Running build first..."
    "$SCRIPT_DIR/build.sh"
fi

echo "Launching Lean Docs Highlighter..."
open "$APP_PATH"

sleep 1

echo "Opening Safari Extensions preferences..."
open "x-apple.systempreferences:com.apple.Safari-Extensions-Preferences"

echo ""
echo "Done! Enable 'Lean Docs Highlighter' in the Safari Extensions panel."
echo "Then visit: https://lean-lang.org/doc/reference/latest/"
