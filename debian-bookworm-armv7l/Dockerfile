# =====================================================================
#   SteamCMD running on Raspberry Pi 2/3 (ARMv7, 32-bit) using Box86
# =====================================================================

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# --- dependencies for building Box86 and running SteamCMD ---
RUN dpkg --add-architecture armhf \
    && apt-get update \
    && apt-get install libc6:armhf git cmake python3 curl -y

# --- build and install Box86 ---
RUN git clone https://github.com/ptitSeb/box86 /opt/box86 && \
    cd /opt/box86 && \
    mkdir build && cd build && \
    cmake .. -DRPI2=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/box86

# --- create steam user ---
RUN useradd -m steam && mkdir -p /steamcmd && chown steam:steam /steamcmd
USER steam
WORKDIR /steamcmd

# --- download SteamCMD (official Valve installer) ---
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
    | tar zxvf - -C /steamcmd

# --- Box86 runtime configuration ---
ENV BOX86_LOG=0
ENV BOX86_PATH=/steamcmd/linux32

# --- launch SteamCMD using Box86 ---
ENTRYPOINT ["box86", "./steamcmd.sh"]

