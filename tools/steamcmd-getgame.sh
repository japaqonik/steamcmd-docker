#!/bin/bash
# =====================================================
# SteamCMD Docker Wrapper for Raspberry Pi (Box86)
# Fully Compose-native version with error handling
# Author: japaqonik
# =====================================================

set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "Usage: $0 <STEAM_APP_ID>"
    exit 1
fi

GAME_ID="$1"

# Check if Steam login exists in Compose-mounted volume
LOGIN_DIR="$HOME/.steamcmd-data"

if [ ! -d "$LOGIN_DIR/config" ]; then
    echo "No Steam login detected. Launching interactive SteamCMD login..."
    if ! docker compose run --rm steamcmd +login; then
        echo "ERROR: Steam login failed. Exiting."
        exit 1
    fi
fi

# Run SteamCMD with AppID inline (uses Compose volumes)
echo "Downloading or updating game with AppID: $GAME_ID..."
if ! docker compose run --rm steamcmd \
    "@ShutdownOnFailedCommand 1" \
    "@NoPromptForPassword 1" \
    "@sSteamCmdForcePlatformType windows" \
    "+force_install_dir /steamcmd/steam_dl" \
    "+login japaqonik" \
    "+app_update $GAME_ID validate" \
    "+quit"; then
    echo "ERROR: Download/update of AppID $GAME_ID failed."
    exit 1
fi

echo "Game $GAME_ID downloaded/updated successfully."
