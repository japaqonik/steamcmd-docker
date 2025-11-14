#!/bin/bash
# =====================================================
# Simple installer: create wrapper in /usr/local/bin
# that calls the real script in ~/steamcmd-tools
# =====================================================

set -euo pipefail

WRAPPER_PATH="/usr/local/bin/steamcmd-getgame"
TARGET_DIR="$HOME/steamcmd-tools"
TARGET_SCRIPT="$TARGET_DIR/steamcmd-getgame"

# Check that target script exists
if [ ! -f "$TARGET_SCRIPT" ]; then
    echo "❌ ERROR: $TARGET_SCRIPT not found."
    echo "Make sure steamcmd-getgame is in ~/steamcmd-tools."
    exit 1
fi

# Create wrapper script content
WRAPPER_CONTENT="#!/bin/bash
\"$TARGET_SCRIPT\" \"\$@\""

# Ask for sudo if needed
if [ ! -w "/usr/local/bin" ]; then
    echo "ℹ️  Root permissions required — using sudo..."
    SUDO="sudo"
else
    SUDO=""
fi

# Write wrapper
echo "Creating wrapper at $WRAPPER_PATH ..."
echo "$WRAPPER_CONTENT" | $SUDO tee "$WRAPPER_PATH" >/dev/null

# Make executable
$SUDO chmod +x "$WRAPPER_PATH"

echo "✅ Installed!"
echo "You can now run: steamcmd-getgame <APPID>"
