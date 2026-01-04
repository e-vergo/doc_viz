#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="Lean Docs Highlighter"
TEST_URL="https://lean-lang.org/doc/reference/latest/The--grind--tactic/Constraint-Propagation"

export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

echo "Building $PROJECT_NAME..."

cd "$SCRIPT_DIR"

xcodebuild \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$PROJECT_NAME (macOS)" \
    -configuration Debug \
    -derivedDataPath "$SCRIPT_DIR/build" \
    build \
    2>&1 | grep -E "(BUILD|error:|warning:)" || true

if [ ! -d "$SCRIPT_DIR/build/Build/Products/Debug/Lean Docs Highlighter.app" ]; then
    echo "Error: Build failed"
    exit 1
fi

echo "Build successful. Opening test page..."
open "$TEST_URL"
