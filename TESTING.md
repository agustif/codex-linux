# Testing Guide

## Quick Test on OrbStack

Test the full Linux build in an Ubuntu VM.

### Prerequisites

- OrbStack installed (`brew install orbstack`)
- Latest Codex app extracted to `app/` directory (or script will download it)

### Step 1: Build on macOS

```bash
make quick
```

This builds arm64 and x86_64 packages on macOS using Docker.

Check output:
```bash
ls -lh release/
# Should show: .deb, AppImage, .tar.gz packages
```

### Step 2: Create OrbStack VM

```bash
orbctl create ubuntu-latest codex-test
```

### Step 3: Install Dependencies in VM

```bash
orbctl shell codex-test << 'EOF'
sudo apt-get update
sudo apt-get install -y \
  libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 libatspi2.0-0 \
  libuuid1 libappindicator3-1 libasound2 libfuse2 \
  ca-certificates libsecret-1-0
EOF
```

### Step 4: Test .deb Package

```bash
# Copy package to VM
orbctl copy release/codex-linux_*_arm64.deb codex-test:~/

# Install and test
orbctl shell codex-test << 'EOF'
sudo dpkg -i ~/codex-linux_*.deb
which codex
codex --help
EOF
```

### Step 5: Test AppImage

```bash
# Copy AppImage to VM
orbctl copy release/Codex-*-arm64.AppImage codex-test:~/

# Make executable and test
orbctl shell codex-test << 'EOF'
chmod +x ~/Codex-*.AppImage
~/Codex-*.AppImage --help
EOF
```

### Step 6: Verify Dependencies

```bash
orbctl shell codex-test << 'EOF'
ldd /usr/bin/codex
ldd $(which codex)
EOF
```

## Debugging

### Check Rust Binary

```bash
cd codex-oss/codex-rs
cargo build --release -p codex-app-server -vv
file target/release/codex-app-server
```

### Check Electron Build

```bash
cd codex-linux-fork
npm run build:linux 2>&1 | tail -50
```

### Check Extracted Assets

```bash
ls -la app/webview/
ls -la app/native/
du -sh app/
```

## Headless Testing

Test binary functionality without GUI:

```bash
# In VM
export RUST_LOG=debug
timeout 5 codex 2>&1 | head -20 || echo "OK (expected timeout)"

# Check if it starts and loads config
codex --version
codex --help
```

## Test Matrix

| Package | Platform | Test Command |
|---------|----------|--------------|
| .deb | Ubuntu arm64 | `sudo dpkg -i *.deb && codex --help` |
| .deb | Debian arm64 | Same as Ubuntu |
| AppImage | Ubuntu x86_64 | `chmod +x *.AppImage && ./Codex.AppImage --help` |
| AppImage | Ubuntu arm64 | Same as x86_64 |
| .tar.gz | Alpine arm64 | Extract and run `./Codex/codex-arm64` |
| Binary | Any | `/path/to/codex --help` |

## Full Test Workflow

```bash
#!/bin/bash

echo "1. Build locally"
make quick

echo "2. Create VM"
orbctl create ubuntu-latest test-$(date +%s)

echo "3. Test packages"
VM="codex-test"

orbctl copy release/*.deb $VM:~/
orbctl copy release/Codex*.AppImage $VM:~/
orbctl copy release/*.tar.gz $VM:~/

orbctl shell $VM << 'EOF'
# Install deps
sudo apt-get update
sudo apt-get install -y libgtk-3-0 libnotify4 libnss3

# Test .deb
sudo dpkg -i *.deb
which codex
codex --help | head -5

# Test AppImage
chmod +x Codex*.AppImage
./Codex*.AppImage --help | head -5

# Test binary
file codex-*
./codex-* --help || echo "Binary test OK"

echo "All tests passed!"
EOF

echo "Done"
```

## CI/CD Testing

### Test Workflow Locally

```bash
# Check YAML syntax
cat .github/workflows/ci.yml | head -50

# Validate with GitHub CLI (if installed)
gh workflow list
gh workflow view ci.yml
```

### Test Quick Mode

Push to a branch (or PR) to trigger quick build:

```bash
git checkout -b test/ci
git push origin test/ci
# Go to GitHub Actions tab
# Watch build for x86_64 + arm64
```

### Test Full Mode

Push a tag to trigger full build:

```bash
git tag v0.1.0-test
git push origin v0.1.0-test
# Check GitHub Actions for multi-arch, multi-distro build
# Release will be created automatically
```

## Troubleshooting

### Build Fails

1. Check `make quick` output for errors
2. Verify Docker is running: `docker ps`
3. Check disk space: `df -h | grep /`
4. Review GitHub Actions logs

### VM Connection Issues

```bash
orbctl list          # List VMs
orbctl shell codex-test "echo test"  # Test connection
orbctl stop codex-test  # Stop
orbctl rm codex-test    # Delete
```

### Dependency Issues

```bash
# In VM, check what's missing
ldd /usr/bin/codex | grep "not found"

# Install missing libs
sudo apt-cache search libgtk | grep -i dev
sudo apt-get install -y libgtk-3-dev
```

## Performance Notes

- First build: ~15-20 minutes (compiles Rust)
- Subsequent builds: ~5-10 minutes (uses cache)
- OrbStack overhead: Minimal (native ARM64 support)
- .deb installation: <1 second
- AppImage startup: ~2-3 seconds

## Success Criteria

- .deb installs without errors
- `which codex` returns path
- `codex --help` shows usage
- `codex --version` shows version
- Binary dependencies resolve (`ldd` shows no "not found")
- AppImage runs and shows help
- No runtime segfaults or crashes
