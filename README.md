# SteamCMD Docker (Raspberry Pi)

This project provides a Docker image for running **SteamCMD** on Raspberry Pi 2/3 devices with 32-bit ARM processors.  

Since SteamCMD is natively built for x86 architecture, this image uses **Box86** – an x86 emulator – to allow SteamCMD to run on Raspberry Pi within a Docker container.  

## Project Goals

- Enable easy deployment of SteamCMD on Raspberry Pi 2/3.
- Provide a Docker environment that eliminates the need for manual SteamCMD installation and configuration.
- Support 32-bit ARM containers with i386 emulation.

## Getting Started

### 1. (Intel/Other Platforms Only) Set up the emulator

If you are not on ARM (e.g., Intel PC), run:

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

This allows the ARM-based Docker image to be build on x86_64 machine via emulation.

### 2. Build the base Box86 image

```bash
cd dockerfiles/bookworm-box86
docker build --platform linux/arm/v7 -t japaqonik/steamcmd:box86 .
```

This image sets up Box86 (x86 emulator) on ARM32 and is used as the base for SteamCMD (but might be used by others as well).

### 3. Build the SteamCMD image

```bash
cd ../bookworm-steamcmd
docker build --platform linux/arm/v7 -t japaqonik/steamcmd .
```

This image extends japaqonik/steamcmd:box86 and installs SteamCMD.

### 4. Install the helper script globally (optional)

```bash
cd ../../tools
sudo ./install.sh
```


This makes steamcmd-getgame.sh available system-wide as steamcmd-getgame.

### 5. Download a Steam game using its App ID

```bash
steamcmd-getgame.sh <APP_ID>
```

This uses Docker Compose to run the SteamCMD container and download the game to the appropriate volume (look at docker-compose).
