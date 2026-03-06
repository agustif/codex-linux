# Codex Linux Fork

**UNOFFICIAL - NOT AFFILIATED WITH OpenAI**

This is a community-maintained Linux build of the Codex.app backend and UI. This project is NOT endorsed, maintained, or supported by OpenAI. Use at your own risk.

See [LEGAL.md](LEGAL.md) for complete disclaimer and licensing information.

---

## Overview

This project provides a complete Linux build system for Codex, the AI code assistant from OpenAI.

It consists of:

1. **Codex Backend (Rust)**
   - Open-source: [github.com/openai/codex](https://github.com/openai/codex)
   - Compiled from source for Linux
   - Provides API and WebSocket server

2. **Codex UI (Electron)**
   - Extracted from Codex.app macOS binary
   - Rebuilt as native Linux Electron application
   - Communicates with backend via JSON-RPC

3. **Build Infrastructure**
   - Docker-based reproducible builds
   - GitHub Actions CI/CD pipeline
   - Multi-distribution support (Ubuntu, Debian, Fedora, Alpine)
   - Multi-architecture support (x86_64, ARM64, ARMv7)

## Features

- **Multiple Linux Distributions**: Ubuntu 22.04, Debian 11, Fedora 38, Alpine
- **Multiple Architectures**: x86_64, ARM64 (Raspberry Pi 4+), ARMv7 (Raspberry Pi 3)
- **Multiple Package Formats**: .deb, .rpm, AppImage, tarballs
- **Automated CI/CD**: GitHub Actions with multi-matrix builds and releases
- **Zero Vendor Approach**: Codex.app downloaded at build time, only source code in repository
- **Open Source**: Build scripts and infrastructure under MIT license
- **Reproducible Builds**: Docker-based for consistency across platforms

## Quick Start

### Ubuntu/Debian

```bash
wget https://github.com/openai/codex-linux/releases/download/latest/codex-linux_0.1.0_arm64.deb
sudo dpkg -i codex-linux_0.1.0_arm64.deb
codex
```

### Fedora/RHEL

```bash
wget https://github.com/openai/codex-linux/releases/download/latest/codex-linux-0.1.0-x86_64.rpm
sudo dnf install ./codex-linux-0.1.0-x86_64.rpm
codex
```

### Alpine / Any Linux

```bash
wget https://github.com/openai/codex-linux/releases/download/latest/Codex-0.1.0-arm64.AppImage
chmod +x Codex-0.1.0-arm64.AppImage
./Codex-0.1.0-arm64.AppImage
```

### Build Locally

```bash
git clone https://github.com/openai/codex-linux
cd codex-linux
make quick       # Fast build with x86_64 + arm64
# or
make ci-build    # Full CI build (downloads Codex.app)
```

## Architecture

```
Codex.app (macOS binary, extracted at build time)
  |
  +-- Webview UI (React/Vite)
  +-- Assets & resources
  |
  v
Build System (This Repository)
  |
  +-- Docker container environment
  +-- Electron builder
  +-- Multi-architecture compilation
  |
  v
Codex-rs (OSS Backend)
  |
  +-- Rust binary compilation (codex-app-server)
  +-- API server (JSON-RPC over WebSocket/stdio)
  |
  v
Linux Packages
  |
  +-- .deb (Ubuntu, Debian)
  +-- .rpm (Fedora, RHEL)
  +-- AppImage (Universal)
  +-- .tar.gz (All platforms)
  +-- Architectures: x86_64, arm64, armv7
```

## Supported Platforms

### Distributions

| Distribution | Version | Architectures | Package Format | Status |
|--------------|---------|---------------|----------------|--------|
| Ubuntu | 22.04 LTS | x86_64, arm64, armv7 | deb, AppImage, tar.gz | Supported |
| Debian | 11+ | x86_64, arm64, armv7 | deb, AppImage, tar.gz | Supported |
| Fedora | 38+ | x86_64, arm64 | rpm, tar.gz | Supported |
| Alpine | Latest, 3.18 | x86_64, arm64 | tar.gz, apk | Supported |

### Devices

- Intel/AMD x86_64: Any Linux distribution
- Apple Silicon: Via Docker Desktop or UTM
- Raspberry Pi 4+: ARM64 with Raspberry Pi OS 64-bit
- Raspberry Pi 3: ARMv7 with Raspberry Pi OS 32-bit
- AWS Graviton: ARM64 instances
- Embedded/IoT: Any ARM-based Linux device

## Build System

### Local Builds

```bash
# Quick build (x86_64 + arm64, Ubuntu only)
make quick

# Full build (all architectures and distributions)
make full

# Manual CI-style build with Codex.app download
make ci-build

# Build-specific formats (requires app/ directory)
make deb
make appimage
make tarball
```

### CI/CD Pipeline

Triggered automatically on:
- **Tag push** (v*): Creates GitHub Release with all packages
- **Push to main/develop**: Builds and uploads artifacts (30 days retention)
- **Manual dispatch**: Specify custom Codex.app version

**Build Matrix:**
- Quick mode (PRs): 2 architectures × 1 distribution (x86_64, arm64 on Ubuntu)
- Full mode (releases): 3 architectures × 3+ distributions (x86_64, arm64, armv7 on Ubuntu, Debian, Fedora, Alpine)

See [CI_CD.md](CI_CD.md) for complete CI/CD documentation.

## Build Artifacts

| Component | Size |
|-----------|------|
| Rust binary (codex-app-server) | ~54 MB |
| .deb package | ~108 MB |
| AppImage | ~142 MB |
| .tar.gz tarball | ~139 MB |

All packages include SHA256 checksums. Verify with:
```bash
sha256sum -c SHA256SUMS
```

## Getting Started

### For Users

1. Download a pre-built package from [Releases](https://github.com/openai/codex-linux/releases)
2. Install for your distribution (see [DISTRO_SUPPORT.md](DISTRO_SUPPORT.md))
3. Run `codex` to start

### For Developers

1. Clone the repository:
   ```bash
   git clone --recursive https://github.com/openai/codex-linux
   cd codex-linux
   ```

2. Install dependencies:
   - Docker and Docker Compose
   - Git with large file support (for Codex.app extraction)
   - 50GB free disk space (for Docker build)

3. Build:
   ```bash
   make quick        # Quick local build
   make ci-build     # Full build with Codex.app download
   ```

4. Find artifacts in `./release/`

### For Continuous Integration

1. Fork the repository
2. Push a semantic version tag:
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```
3. GitHub Actions automatically builds and creates a release

## Documentation

| Document | Purpose |
|----------|---------|
| [CI_CD.md](CI_CD.md) | CI/CD architecture, workflows, local testing |
| [BUILD_MATRIX.md](BUILD_MATRIX.md) | Multi-architecture support, platforms, troubleshooting |
| [DISTRO_SUPPORT.md](DISTRO_SUPPORT.md) | Per-distribution installation, compatibility, performance |
| [CODEX_REVERSE_ENGINEERING.md](CODEX_REVERSE_ENGINEERING.md) | Technical deep-dive, binary analysis, architecture |
| [LEGAL.md](LEGAL.md) | Legal disclaimer, licensing, intellectual property |
| [AGENTS.md](AGENTS.md) | Build commands, project structure, development guide |

## Legal & Licensing

### This Repository

```
Copyright (c) 2024 Community Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

**License**: MIT ([LICENSE](LICENSE))

### Component Licenses

| Component | License | Source | Status |
|-----------|---------|--------|--------|
| Build scripts & infrastructure | MIT | This repository | Open Source |
| codex-rs backend | Apache-2.0 | [github.com/openai/codex](https://github.com/openai/codex) | Open Source |
| Codex.app UI | Proprietary | Downloaded at build time | Proprietary |

### Important Notes

1. **Codex.app is NOT included in this repository**
   - Downloaded from OpenAI at build time
   - You accept the Codex.app EULA when building
   - See https://codex.openai.com/ for terms

2. **Not endorsed by OpenAI**
   - This is a community fork
   - No official support
   - Use entirely at your own risk

3. **Intellectual Property**
   - Codex is a trademark of OpenAI
   - This project respects OpenAI's IP rights
   - No redistribution of proprietary components

See [LEGAL.md](LEGAL.md) for full legal information.

## Troubleshooting

### Build Failures

1. Ensure Docker is running and has sufficient resources
2. Verify 50GB free disk space
3. Check network connectivity for Codex.app download
4. Review GitHub Actions logs for detailed error messages

### Runtime Issues

1. **Missing libraries**: Install via package manager
   ```bash
   # Ubuntu/Debian
   sudo apt install libgtk-3-0 libnotify4

   # Fedora
   sudo dnf install gtk3 libnotify
   ```

2. **Permission denied on AppImage**
   ```bash
   chmod +x Codex-*.AppImage
   ```

3. **Binary not found**: Add to PATH or use absolute path
   ```bash
   export PATH="/opt/codex:$PATH"
   ```

See [BUILD_MATRIX.md](BUILD_MATRIX.md#troubleshooting) for distribution-specific issues.

## Contributing

### Improving the Build System

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/improvement`
3. Make changes
4. Test locally: `make quick`
5. Push and open a pull request

### Adding Distribution Support

See [DISTRO_SUPPORT.md](DISTRO_SUPPORT.md#contributing-new-distributions)

### Reporting Issues

- **Build failures**: Include Docker version and distribution
- **Runtime issues**: Include distribution, architecture, package format
- **Feature requests**: Describe use case and requirements

## Related Projects

- **Codex (OSS)**: https://github.com/openai/codex
- **Codex.app**: https://codex.openai.com/
- **Electron**: https://www.electronjs.org/
- **Rust**: https://www.rust-lang.org/

## Support

This is a community project with no official support.

- **GitHub Issues**: Report bugs or ask questions
- **GitHub Discussions**: General help and sharing
- **Documentation**: See files listed in Documentation section
- **OpenAI**: For official Codex issues, contact https://codex.openai.com/

**Note**: OpenAI does not provide support for this project.

---

## Disclaimer

**This project is UNOFFICIAL and NOT affiliated with OpenAI.**

- No endorsement from OpenAI
- No official support
- Use at your own risk
- Respect Codex.app license and terms
- Community-maintained

By using this project, you agree to the terms in [LEGAL.md](LEGAL.md).

---

**Made by the community**

Questions or issues? See [LEGAL.md](LEGAL.md) or open an issue on GitHub.
