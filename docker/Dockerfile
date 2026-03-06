# Build environment for Codex Linux Fork
# Based on Ubuntu 22.04 for maximum compatibility
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    curl \
    wget \
    git \
    pkg-config \
    libssl-dev \
    libcap-dev \
    # Node.js dependencies
    ca-certificates \
    # Electron builder dependencies
    libsecret-1-dev \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    libatspi2.0-0 \
    libuuid1 \
    libappindicator3-1 \
    libasound2 \
    # For AppImage
    libfuse2 \
    file \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set up working directory
WORKDIR /build

# Copy project files
COPY codex-oss/ /build/codex-oss/
COPY codex-linux-fork/ /build/codex-linux-fork/

# Build script
COPY docker/build.sh /build/build.sh
RUN chmod +x /build/build.sh

# Output directory
VOLUME /output

CMD ["/build/build.sh"]
