FROM debian:12

RUN dpkg --add-architecture i386 \
    && apt-get update \
    # TODO: Trim this list down
    && apt install -y software-properties-common apt-transport-https dirmngr ca-certificates curl

RUN sed -i 's#^Components: .*#Components: main non-free contrib#g' /etc/apt/sources.list.d/debian.sources \
    && add-apt-repository -sy -c 'contrib' \
    && add-apt-repository -sy -c 'non-free' 

RUN curl -s http://repo.steampowered.com/steam/archive/stable/steam.gpg > /usr/share/keyrings/steam.gpg \
    && echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam" > /etc/apt/sources.list.d/steam.list \
    # Auto agree to Steam license
    && echo steam steam/question select "I AGREE" | sudo debconf-set-selections \
    && echo steam steam/license note '' | sudo debconf-set-selections \
    && apt-get update \
    && apt-get install -y lib32gcc-s1 steamcmd steam-launcher

ENV PROTON_NAME=GE-Proton8-21
ENV PROTON_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/$PROTON_NAME/$PROTON_NAME.tar.gz"
ENV PROTON_TGZ="${PROTON_NAME}.tar.gz"

# TODO: Use curl instead
RUN mkdir -p /opt/game-resources
RUN curl $PROTON_URL -o "/opt/game-resources/$PROTON_TGZ"

# Create the Steam user. Everything from here is done as this steam user.
RUN useradd -m -U steam -u 1000
RUN mkdir /game \
    && chown steam:steam /game

USER steam:steam

RUN /usr/games/steamcmd +login anonymous +quit
ENV STEAMDIR="/home/steam/.local/share/Steam"
RUN mkdir -p "$STEAMDIR/compatibilitytools.d" \
    && tar -x -C "$STEAMDIR/compatibilitytools.d/" -f "/opt/game-resources/$PROTON_TGZ" \
    && mkdir -p "$STEAMDIR/steamapps/compatdata" \
    && cp "$STEAMDIR/compatibilitytools.d/$PROTON_NAME/files/share/default_pfx" "$STEAMDIR/steamapps/compatdata/2430930" -r

ENV XDG_RUNTIME_DIR=/run/user/1000
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAMDIR"
ENV STEAM_COMPAT_DATA_PATH="$STEAMDIR/steamapps/compatdata/2430930"

ADD entrypoint.sh /entrypoint.sh

# Launch args like TheIsland_WP?listen?SessionName=ARK_Server -NoBattlEye
ENV LAUNCH_ARGS=TheIsland_WP?listen
ENV SKIP_UPDATE=0

USER root
RUN chmod ugo+x entrypoint.sh
USER steam:steam

ENTRYPOINT /entrypoint.sh
