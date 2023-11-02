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

LOG_FILE=/game/ShooterGame/Saved/Logs/ShooterGame.log
mkdir -p `dirname $LOG_FILE`
touch $LOG_FILE
tail -f /game/ShooterGame/Saved/Logs/ShooterGame.log -n 0 &

cd "/game/ShooterGame/Binaries/Win64"

handle_sigterm() {
    kill -TERM $child 2>/dev/null
    wait $child
}

$STEAMDIR/compatibilitytools.d/$PROTON_NAME/proton run ArkAscendedServer.exe $LAUNCH_ARGS &

child=$!
trap handle_sigterm SIGTERM
trap handle_sigterm SIGINT

wait $child