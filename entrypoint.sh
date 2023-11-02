#!/bin/bash

set -e

if [ "$SKIP_STEAM" -eq 0 ]; then
    # Update steam, if required
    echo "Running app_update and validation"
    /usr/games/steamcmd $STEAM_ARGS
fi

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAMDIR"
export STEAM_COMPAT_DATA_PATH="$STEAMDIR/steamapps/compatdata/2430930"

cd "/game/ShooterGame/Binaries/Win64"
exec $STEAMDIR/compatibilitytools.d/$PROTON_NAME/proton run ArkAscendedServer.exe $LAUNCH_ARGS
