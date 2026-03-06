#!/bin/bash
# Quick build for Codex Linux Fork
# Run this on a Linux machine

set -e

cd "$(dirname "$0")"

echo "=== Quick Build for Codex Linux Fork ==="

# 1. Build Rust binary
echo "Building Rust binary from OSS..."
if [ -d "../codex-oss/codex-rs" ]; then
    cd ../codex-oss/codex-rs
    cargo build --release -p codex-app-server
    cd -
    cp ../codex-oss/codex-rs/target/release/codex-app-server bin/codex
    echo "✓ Binary built and copied to bin/codex"
else
    echo "⚠ OSS repo not found. You need to build codex-app-server and place it at bin/codex"
fi

# 2. Download ripgrep
if [ ! -f "resources/rg" ]; then
    echo "Downloading ripgrep..."
    curl -sL https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz | \
        tar xz -C resources --strip-components=1 ripgrep-14.1.0-x86_64-unknown-linux-musl/rg
    chmod +x resources/rg
    echo "✓ ripgrep downloaded"
fi

# 3. Install dependencies
echo "Installing Node dependencies..."
npm install
echo "✓ Dependencies installed"

# 4. Rebuild native modules
echo "Rebuilding native modules for Electron..."
npm run rebuild
echo "✓ Native modules rebuilt"

# 5. Build packages
echo ""
echo "Ready to build! Choose an option:"
echo "  npm run build:deb      - Build .deb package"
echo "  npm run build:appimage - Build AppImage"
echo "  npm run build:linux    - Build all formats"
echo "  npm start              - Run directly for testing"
