# Codex Linux Fork - CI/CD Architecture

This project uses a clean, zero-vendor approach where Codex.app is downloaded at build time from official OpenAI sources. The repository contains only open-source code and build scripts.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│ GitHub Actions Workflow (.github/workflows/build-linux.yml) │
├─────────────────────────────────────────────────────────┤
│ 1. Download Codex.app DMG from OpenAI                   │
│ 2. Extract webview, assets, and app.asar                │
│ 3. Run Docker build (Makefile → build.sh)               │
│ 4. Build Rust binary (codex-app-server)                 │
│ 5. Build Electron wrapper (codex-linux-fork)            │
│ 6. Create artifacts (.deb, AppImage, .tar.gz)           │
│ 7. Upload to GitHub Releases                            │
└─────────────────────────────────────────────────────────┘
```

## Building Locally

### Quick Build
```bash
make build
```

This assumes `app/` directory exists with extracted Codex.app contents.

### Full CI-style Build (Download + Build)
```bash
make ci-build
```

This downloads the latest Codex.app and builds everything.

### Manual Download (for specific version)
```bash
# Download and build
./scripts/ci-build.sh 0.1.2

# Or use Makefile
make ci-build
```

## GitHub Actions Workflow

### Trigger Events

1. **On Tag Push** (Recommended)
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```
   → Automatically builds and creates a GitHub Release

2. **On Push to Main**
   → Builds and uploads artifacts for 30 days

3. **Manual Dispatch** (Workflow UI)
   → Specify custom Codex.app version or use latest

### Workflow File

**Location**: `.github/workflows/build-linux.yml`

**Key Steps**:
1. Checkout repository with submodules
2. Download Codex.app from OpenAI sources
3. Extract webview, assets, and app.asar
4. Run Docker build with `make build`
5. Create and sign artifacts
6. Upload to GitHub Releases (if tagged)

### Artifacts

After a successful build, GitHub Actions uploads:
- `Codex-0.1.0-arm64.AppImage` (142 MB)
- `codex-linux_0.1.0_arm64.deb` (108 MB)
- `codex-linux-0.1.0-arm64.tar.gz` (139 MB)
- `codex-linux-x64` (Rust binary, 53 MB)
- `SHA256SUMS` (checksums)

## Codex.app Download Strategy

The workflow tries these sources in order:

1. `https://storage.googleapis.com/codex-releases/Codex-{VERSION}.dmg`
2. `https://codex-releases.s3.amazonaws.com/Codex-{VERSION}.dmg`
3. `https://github.com/openai/codex/releases/download/v{VERSION}/Codex-{VERSION}.dmg`

If all fail, the workflow provides manual download instructions.

## Repository Structure

```
codex_app_reverse_engineer/
├── .github/workflows/build-linux.yml    # CI/CD pipeline
├── scripts/ci-build.sh                  # CI build orchestration
├── Makefile                             # Build targets
├── docker/                              # Docker build environment
├── codex-oss/                           # Open-source codex-rs
├── codex-linux-fork/                    # Electron wrapper
├── app/                                 # (Generated) Extracted Codex.app
└── release/                             # (Generated) Build artifacts
```

## What's NOT in the Repository

- ❌ Codex.app binary (0.5+ GB)
- ❌ Extracted webview assets (large)
- ❌ Build artifacts (Linux packages)
- ❌ node_modules, target/, dist/

These are generated at build time or download time.

## Security & Licensing

### Repository License
- Build scripts and Linux fork: **MIT License**
- Codex-rs (OSS): **Apache-2.0 License**

### Binary Components
- **Codex.app**: Downloaded from official OpenAI sources at build time
  - License: See Codex.app EULA
  - Not included in repository
  - Used only for webview and assets extraction

This keeps the repository clean and ensures compliance with:
- ✅ Codex.app license (no redistribution)
- ✅ Codex-rs open-source license
- ✅ Build script IP rights

## Environment Variables

For local builds:

```bash
# Use specific Codex version
export CODEX_VERSION="0.1.2"

# Override download source
export CODEX_DMG_URL="https://custom.example.com/Codex.dmg"

# Docker build flags
export DOCKER_BUILDKIT=1
```

## Continuous Integration Best Practices

### 1. Version Management

Tag releases semantically:
```bash
git tag -a v0.1.0 -m "Release v0.1.0 - Linux fork"
git push origin v0.1.0
```

### 2. Monitoring Builds

Check workflow status:
```bash
gh workflow view build-linux.yml
gh run list --workflow build-linux.yml
```

### 3. Troubleshooting Failed Builds

1. Check workflow logs on GitHub Actions
2. Run locally with `make ci-build` to reproduce
3. Check Codex.app version availability
4. Verify Docker daemon is running

### 4. Release Notes

The workflow auto-generates release notes with:
- Download links for all formats
- Installation instructions
- Build metadata
- SHA256 checksums

## Customization

### Custom Build Targets

Edit `.github/workflows/build-linux.yml` to:
- Build for additional architectures (x86_64, etc.)
- Push to additional registries (Docker Hub, Artifact Hub)
- Run additional tests before release

### Custom Codex.app Source

For private/internal Codex builds:

```yaml
# In .github/workflows/build-linux.yml
- name: Download Codex.app
  run: |
    curl -H "Authorization: Bearer ${{ secrets.CODEX_DOWNLOAD_TOKEN }}" \
      -o Codex.dmg \
      https://private.example.com/codex-releases/latest.dmg
```

## Performance

### Build Times
- **Rust compilation**: ~12 minutes (first build, cached after)
- **Electron packaging**: ~3 minutes
- **Total**: ~20 minutes (depends on network)

### Optimization Tips
- Use GitHub Actions runners with sufficient CPU/RAM
- Cache Docker layers between builds
- Pre-download Codex.app if possible

## FAQs

**Q: Why download Codex.app instead of including it?**
- A: Reduces repo size from 0.5+ GB to ~50 MB
- Keeps repository compliance clean
- Ensures latest Codex.app is always used

**Q: Can I build offline?**
- A: Yes, if you have an extracted `app/` directory and all dependencies
- Run `make build` to skip Codex.app download

**Q: How do I test builds locally before pushing?**
- A: Use `make ci-build` to run the full CI pipeline locally

**Q: Can I use pre-built Codex binaries?**
- A: Yes, extract them to `app/` and run `make build`
- See CODEX_REVERSE_ENGINEERING.md for extraction steps

## Related Documentation

- [Build System](README.md) - How the build process works
- [Reverse Engineering Guide](CODEX_REVERSE_ENGINEERING.md) - Detailed technical info
- [Docker Build Environment](docker/README.md) - Container build details
