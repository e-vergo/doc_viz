#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
PROJECT_NAME="Lean Docs Highlighter"

# Use Xcode's developer directory (not Command Line Tools)
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

echo "Building $PROJECT_NAME..."

cd "$PROJECT_DIR"

# Build the macOS app (which includes the extension)
xcodebuild \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME (macOS)" \
    -configuration Debug \
    -derivedDataPath "$PROJECT_DIR/build" \
    build

# Find the built app
APP_PATH=$(find "$PROJECT_DIR/build" -name "*.app" -type d | grep -v Extension | head -1)

if [ -z "$APP_PATH" ]; then
    echo "Error: Could not find built app"
    exit 1
fi

echo ""
echo "Build successful!"
echo "App location: $APP_PATH"
echo ""
echo "Next steps:"
echo "1. Run the app once to register the extension:"
echo "   open \"$APP_PATH\""
echo ""
echo "2. Enable in Safari:"
echo "   - Safari > Settings > Extensions"
echo "   - Check 'Lean Docs Highlighter'"
echo ""
echo "If the extension doesn't appear, you may need to:"
echo "   - Enable: Safari > Develop > Allow Unsigned Extensions"
echo "   - (Enable Develop menu in Safari > Settings > Advanced first)"
