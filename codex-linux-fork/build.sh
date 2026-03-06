#!/bin/bash
# Build script for Codex Linux Fork
# This script prepares everything needed for Linux builds

set -e

FORK_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$FORK_DIR"

echo "=== Codex Linux Fork Build Script ==="

# Check if we're on Linux for native builds
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Building on Linux - native compilation"
    NATIVE_BUILD=true
else
    echo "Building on non-Linux OS - cross-compilation required"
    NATIVE_BUILD=false
fi

# Step 1: Build Rust binary from OSS
echo ""
echo "Step 1: Building Rust binary..."
OSS_PATH="../codex-oss/codex-rs"

if [[ "$NATIVE_BUILD" == true ]]; then
    echo "  Building natively for Linux..."
    cd "$OSS_PATH"
    cargo build --release -p codex-app-server
    cp target/release/codex-app-server "$FORK_DIR/bin/codex"
else
    echo "  Cross-compilation setup required."
    echo "  Run this on a Linux machine or use cross-rs:"
    echo "    cargo install cross"
    echo "    cross build --release -p codex-app-server --target x86_64-unknown-linux-gnu"
    echo ""
    echo "  Or download pre-built binary if available."
fi

cd "$FORK_DIR"

# Step 2: Download ripgrep for Linux
echo ""
echo "Step 2: Downloading ripgrep..."
RG_VERSION="14.1.0"
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"

if [[ ! -f "resources/rg" ]]; then
    echo "  Downloading ripgrep..."
    curl -sL "$RG_URL" | tar xz -C resources --strip-components=1 "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl/rg"
    chmod +x resources/rg
else
    echo "  ripgrep already exists"
fi

# Step 3: Install Node dependencies
echo ""
echo "Step 3: Installing Node dependencies..."
npm install

# Step 4: Rebuild native modules for Linux
if [[ "$NATIVE_BUILD" == true ]]; then
    echo ""
    echo "Step 4: Rebuilding native modules for Linux..."
    npm run rebuild
else
    echo ""
    echo "Step 4: Native modules need to be rebuilt on Linux target."
    echo "  Run 'npm run rebuild' on the target Linux machine."
fi

# Step 5: Build the Electron app
echo ""
echo "Step 5: Ready to build!"
echo ""
echo "To build Linux packages, run on a Linux machine:"
echo "  npm run build:linux      # Build all formats"
echo "  npm run build:deb        # Build .deb only"
echo "  npm run build:appimage   # Build AppImage only"
echo ""
echo "Or for distribution:"
echo "  npm run build:tarball    # Build portable tar.gz"
