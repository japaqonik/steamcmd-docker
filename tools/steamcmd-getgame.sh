#!/bin/bash
# =====================================================
# SteamCMD Docker Wrapper for Raspberry Pi (Box86)
# Docker-only version (no Compose)
# Persistent config for install dir
# Mandatory positional AppID
# Login dir fixed, cannot be changed
# Creates directories if they do not exist
# =====================================================

set -euo pipefail

CONFIG_FILE="$HOME/.steamcmd-getgame.conf"

# Fixed login directory
LOGIN_DIR="$HOME/.steamcmd-data"

# Default install directory
DEFAULT_INSTALL_DIR="$HOME/steam_dl"
IMAGE="japaqonik/steamcmd:latest"

# Load config if exists
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Check that at least one argument (AppID) exists
if [ $# -lt 1 ]; then
    echo "Usage: $0 <STEAM_APP_ID> [--install-dir|-id <PATH>]"
    exit 1
fi

# Positional argument: AppID
APP_ID="$1"
shift

# Parse optional install-dir argument
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --install-dir|-id)
            INSTALL_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 <STEAM_APP_ID> [--install-dir|-id <PATH>]"
            exit 1
            ;;
    esac
done

# Save current configuration (only install dir)
cat > "$CONFIG_FILE" << EOF
INSTALL_DIR="$INSTALL_DIR"
EOF

# Create directories if they don't exist
mkdir -p "$LOGIN_DIR"
mkdir -p "$INSTALL_DIR"

# Function to run SteamCMD update
run_update() {
    docker run --rm \
        -v "$LOGIN_DIR:/home/steam/.steam" \
        -v "$INSTALL_DIR:/steamcmd/steam_dl" \
        "$IMAGE" \
        "@ShutdownOnFailedCommand 1" \
        "@NoPromptForPassword 1" \
        "@sSteamCmdForcePlatformType windows" \
        "+force_install_dir /steamcmd/steam_dl" \
        "+app_update $APP_ID validate" \
        "+quit"
}

# Check if a saved Steam token exists
if [ -d "$LOGIN_DIR/config" ]; then
    echo "Existing Steam login detected. Trying to update game..."
    if run_update; then
        echo "Game $APP_ID downloaded/updated successfully."
        exit 0
    else
        echo "Update failed. Token might be expired."
    fi
else
    echo "No Steam login detected."
fi

# Interactive login only if token does not exist or is expired
echo "Launching interactive SteamCMD login..."
docker run --rm -it -v "$LOGIN_DIR:/home/steam/.steam" "$IMAGE" +login

# Retry game update after successful login
echo "Retrying game update..."
if run_update; then
    echo "Game $APP_ID downloaded/updated successfully after login."
else
    echo "ERROR: Download/update failed even after login."
    exit 1
fi
