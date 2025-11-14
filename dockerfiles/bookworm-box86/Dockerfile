FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies (cached layer)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential cmake python3 gcc g++ curl \
    && rm -rf /var/lib/apt/lists/*

# Clone Box86 repo (cached if Dockerfile above doesn't change)
RUN git clone --depth 1 https://github.com/ptitSeb/box86.git /tmp/box86

# Build and install Box86
RUN cd /tmp/box86 && mkdir build && cd build && \
    cmake .. -DARM_DYNAREC=ON -DRPI2=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/box86

# Optional: disable Box86 logging
ENV BOX86_LOG=0
