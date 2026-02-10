#!/bin/bash
set -euo pipefail

echo "Building InfiniteNightShift..."
swift build -c release

APP_DIR=".build/InfiniteNightShift.app/Contents/MacOS"
RES_DIR=".build/InfiniteNightShift.app/Contents/Resources"
mkdir -p "$APP_DIR" "$RES_DIR"

cp .build/release/InfiniteNightShift "$APP_DIR/"
cp Sources/InfiniteNightShift/Info.plist ".build/InfiniteNightShift.app/Contents/"
cp AppIcon.icns "$RES_DIR/"

echo "Built .build/InfiniteNightShift.app"
