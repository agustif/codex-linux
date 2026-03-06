#!/bin/bash
# Build script run inside Docker container
set -ex

echo "=========================================="
echo "  Codex Linux Fork - Docker Build"
echo "=========================================="

cd /build

# Step 1: Build Rust binary
echo ""
echo "[1/5] Building Rust binary (codex-app-server)..."
cd codex-oss/codex-rs
cargo build --release -p codex-app-server -vv
cd -
cp codex-oss/codex-rs/target/release/codex-app-server codex-linux-fork/bin/codex
chmod +x codex-linux-fork/bin/codex
echo "✓ Rust binary built: $(du -h codex-linux-fork/bin/codex | cut -f1)"

# Step 2: Download ripgrep
echo ""
echo "[2/5] Downloading ripgrep..."
RG_VERSION="14.1.0"
curl -sL "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz" | \
    tar xz -C codex-linux-fork/resources --strip-components=1 "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl/rg"
chmod +x codex-linux-fork/resources/rg
echo "✓ ripgrep downloaded"

# Step 3: Install Node dependencies
echo ""
echo "[3/5] Installing Node dependencies..."
cd codex-linux-fork
npm install
echo "✓ Dependencies installed"

# Step 4: Build packages
echo ""
echo "[4/4] Building packages..."
npm run build:linux

# Copy outputs
echo ""
echo "Copying outputs to /output..."
cp -r dist/* /output/ 2>/dev/null || echo "No dist files found"
cp bin/codex /output/codex-linux-x64 2>/dev/null || true

echo ""
echo "=========================================="
echo "  Build Complete!"
echo "=========================================="
echo ""
echo "Outputs:"
ls -lh /output/ 2>/dev/null || echo "Check /build/codex-linux-fork/dist/"
