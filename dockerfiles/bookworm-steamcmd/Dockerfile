FROM japaqonik/steamcmd:box86

ARG PUID=1000

ENV USER=steam
ENV HOMEDIR="/home/${USER}"
ENV STEAMCMDDIR="${HOMEDIR}/steamcmd"

ENV DEBIAN_FRONTEND=noninteractive

# Install ARM runtime + i386 libraries required by SteamCMD
RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        nano \
        curl \
        locales \
        libc6:i386 \
        libstdc++6:i386 \
        libgcc-s1:i386 \
        libtinfo5:i386 \
        zlib1g:i386 \
        libcurl4:i386 \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    # Create Steam user
    && useradd -u "${PUID}" -m "${USER}" \
    # Download and setup SteamCMD
    && su "${USER}" -c \
        "mkdir -p \"${STEAMCMDDIR}\" \
        && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' \
            | tar xvzf - -C \"${STEAMCMDDIR}\" \
        && \"${STEAMCMDDIR}/steamcmd.sh\" +quit \
        # Symlinks for compatibility (linux32 + linux64)
        && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
        && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
        && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
        && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
        && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
        && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
    && rm -rf /var/lib/apt/lists/*

USER ${USER}
WORKDIR ${STEAMCMDDIR}

# SteamCMD CLI wrapper via Box86
ENTRYPOINT ["box86", "steamcmd.sh"]
