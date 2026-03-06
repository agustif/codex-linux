# Codex Linux Fork

> ⚠️ **UNOFFICIAL - NOT AFFILIATED WITH OpenAI**
>
> This is a **community-maintained Linux build** of the Codex.app backend and UI. This project is **NOT** endorsed, maintained, or supported by OpenAI. Use at your own risk.

## Disclaimer

- **This project is unofficial** and has no affiliation with OpenAI
- **Codex.app is proprietary** - this project only provides Linux packaging and build infrastructure
- **Use at your own risk** - no warranty or support from OpenAI
- **Respect the license** - Codex.app has its own EULA; follow it
- **Open Source Components** - This repository contains only OSS build scripts and the OSS codex-rs backend

See [LICENSE](LICENSE) and [LEGAL.md](LEGAL.md) for details.

---

## What is This?

This project provides a **complete Linux build system** for Codex, the AI code assistant from OpenAI.

It consists of:

1. **Codex Backend** (Rust)
   - Open-source: [github.com/openai/codex](https://github.com/openai/codex)
   - Compiled from source for Linux
   - Provides API and websocket server

2. **Codex UI** (Electron)
   - Extracted from Codex.app
   - Rebuilt as Linux Electron app
   - Communicates with backend via JSON-RPC

3. **Build Infrastructure** (This repo)
   - Docker build system
   - CI/CD pipelines (GitHub Actions)
   - Multi-distro support (Ubuntu, Fedora, Alpine, Debian)
   - Multi-arch (x86_64, ARM64, ARMv7)

## ✨ Features

- ✅ **Multiple Linux Distributions**: Ubuntu, Debian, Fedora, Alpine
- ✅ **Multiple Architectures**: x86_64, ARM64 (Raspberry Pi 4+), ARMv7
- ✅ **Multiple Packages**: .deb, .rpm, AppImage, tarballs
- ✅ **Automated CI/CD**: GitHub Actions builds and releases
- ✅ **Zero Vendor**: Only source code in repo, Codex.app downloaded at build time
- ✅ **Open Source**: Build scripts and infrastructure are MIT licensed
- ✅ **Reproducible**: Docker-based builds for consistency

## 📦 Quick Start

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

### Or Build Locally

```bash
git clone https://github.com/openai/codex-linux
cd codex-linux
make ci-build  # Downloads Codex.app and builds
```

## 🏗️ Architecture

```
┌──────────────────────────────────────┐
│ Codex.app (macOS binary)             │
│ ↓ (extracted at build time)          │
│ - Webview UI (React)                 │
│ - Assets & resources                 │
└──────────────────────────────────────┘
              ↓
┌──────────────────────────────────────┐
│ Build System (This Repo)             │
│ - Docker container                   │
│ - Electron builder                   │
│ - Multi-arch compilation             │
└──────────────────────────────────────┘
              ↓
┌──────────────────────────────────────┐
│ Codex-rs (OSS Backend)               │
│ github.com/openai/codex              │
│ - Rust binary compilation            │
│ - API server (JSON-RPC)              │
│ - WebSocket support                  │
└──────────────────────────────────────┘
              ↓
┌──────────────────────────────────────┐
│ Linux Packages                       │
│ .deb, .rpm, AppImage, .tar.gz        │
│ x86_64, arm64, armv7                 │
└──────────────────────────────────────┘
```

## 📋 Supported Platforms

### Distributions

| Distro | Version | Arch | Package | Status |
|--------|---------|------|---------|--------|
| Ubuntu | 22.04 LTS | x86_64, arm64, armv7 | deb, AppImage | ✅ |
| Debian | 11, 12 | x86_64, arm64, armv7 | deb, AppImage | ✅ |
| Fedora | 38, 39 | x86_64, arm64 | rpm | ✅ |
| Alpine | Latest, 3.18 | x86_64, arm64 | tar, apk | ✅ |

### Devices

- **Intel/AMD**: Any x86_64 Linux
- **Apple Silicon**: Via Docker Desktop or UTM
- **Raspberry Pi 4+**: ARM64 (Raspberry Pi OS 64-bit)
- **Raspberry Pi 3**: ARMv7 (Raspberry Pi OS 32-bit)
- **AWS Graviton**: ARM64 instances
- **Embedded/IoT**: Any ARM device

## 🔧 Build System

### Local Build

```bash
# Quick build (requires extracted app/ directory)
make build

# Full CI-style build (downloads Codex.app)
make ci-build

# Build specific format
make deb
make appimage
make tarball
```

### CI/CD Pipeline

Automatic builds on:
- **Tag push** (`v*`) → GitHub Release
- **Main branch** → Artifacts (30 days)
- **Manual dispatch** → Custom version

Builds all combinations:
- 3+ distributions × 2-3 architectures
- Total: ~12 build jobs
- Time: 1-2 hours

See [CI_CD.md](CI_CD.md) for full details.

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [CI_CD.md](CI_CD.md) | CI/CD architecture, GitHub Actions, local testing |
| [BUILD_MATRIX.md](BUILD_MATRIX.md) | Multi-arch support, platforms, troubleshooting |
| [DISTRO_SUPPORT.md](DISTRO_SUPPORT.md) | Per-distro installation, compatibility, performance |
| [CODEX_REVERSE_ENGINEERING.md](CODEX_REVERSE_ENGINEERING.md) | Technical deep-dive, binary analysis |
| [AGENTS.md](AGENTS.md) | Build commands, project structure |

## ⚖️ Legal & Licensing

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

### Codex Components

| Component | License | Source | Status |
|-----------|---------|--------|--------|
| **codex-rs** | Apache-2.0 | [github.com/openai/codex](https://github.com/openai/codex) | ✅ OSS |
| **Codex.app UI** | Proprietary | Downloaded at build | ⚠️ Proprietary |
| **Build Scripts** | MIT | This repository | ✅ OSS |

### Important Notes

1. **Codex.app is NOT included in this repository**
   - It's downloaded from OpenAI at build time
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

## 🚀 Getting Started

### For Users

1. Download a pre-built package from [Releases](https://github.com/openai/codex-linux/releases)
2. Install for your distro (see [DISTRO_SUPPORT.md](DISTRO_SUPPORT.md))
3. Run `codex` to start

### For Developers

1. Clone the repo:
   ```bash
   git clone --recursive https://github.com/openai/codex-linux
   cd codex-linux
   ```

2. Install Docker and Docker Compose

3. Build:
   ```bash
   make ci-build  # Full build with download
   # or
   make build     # Quick build (requires app/ directory)
   ```

4. Find artifacts in `./release/`

### For CI/CD

1. Fork the repository
2. Push a tag: `git tag v0.1.0 && git push origin v0.1.0`
3. GitHub Actions automatically builds and creates a release

## 🔍 Technical Details

### What's Included

- **Rust Backend**: Compiled from codex-rs source
- **Electron Wrapper**: Rebuilt as native Linux app
- **Webview Assets**: Extracted from Codex.app
- **Build System**: Docker, npm, cargo

### What's NOT Included

- ❌ Codex.app binary (downloaded at build time)
- ❌ Proprietary components
- ❌ API keys or credentials
- ❌ Analytics or telemetry

### Build Sizes

| Component | Size |
|-----------|------|
| Rust binary | 54 MB |
| .deb package | 108 MB |
| AppImage | 142 MB |
| .tar.gz | 139 MB |

## 🐛 Troubleshooting

### Build Fails

1. **Docker not running**: Start Docker daemon
2. **Out of disk space**: Need ~50GB for Docker
3. **Codex.app download fails**: Check internet, try manual download
4. **Permission denied**: Use `sudo` or `docker` group

See [BUILD_MATRIX.md](BUILD_MATRIX.md#troubleshooting) for distro-specific issues.

### Runtime Issues

1. **Missing libraries**: Install via package manager
   ```bash
   # Ubuntu/Debian
   sudo apt install libgtk-3-0 libnotify4
   
   # Fedora
   sudo dnf install gtk3 libnotify
   ```

2. **Permission denied**: Make binary executable
   ```bash
   chmod +x Codex-*.AppImage
   ```

3. **Cannot find codex**: Add to PATH
   ```bash
   export PATH="/opt/codex:$PATH"
   ```

## 🤝 Contributing

### Improving the Build System

1. Fork the repository
2. Create a branch: `git checkout -b feature/my-improvement`
3. Make changes
4. Test locally: `make build`
5. Push and open a PR

### Adding Distro Support

See [DISTRO_SUPPORT.md](DISTRO_SUPPORT.md#contributing-new-distributions)

### Reporting Issues

- **Build failures**: Include Docker version and distro
- **Runtime issues**: Include distro, arch, package format
- **Feature requests**: Describe use case

## 📞 Support

This is a **community project** with **no official support**.

### Getting Help

- **GitHub Issues**: Report bugs or ask questions
- **GitHub Discussions**: General help and sharing
- **Documentation**: See [docs/](docs/) directory
- **OpenAI**: For Codex itself, see https://codex.openai.com/

### NOTE: Not OpenAI Support

OpenAI does not provide support for this project. For official Codex issues, contact OpenAI directly.

## 🎯 Roadmap

### Current
- ✅ Multi-arch builds (x86_64, arm64, armv7l)
- ✅ Multi-distro packages (Ubuntu, Fedora, Alpine, Debian)
- ✅ GitHub Actions CI/CD
- ✅ Zero vendor approach

### Planned
- [ ] RPM/DNF package improvements
- [ ] Snap Store integration
- [ ] Flatpak support
- [ ] AUR package (Arch Linux)
- [ ] Code signing for releases
- [ ] Docker Hub images
- [ ] Multi-distro testing matrix

## 📄 License Summary

| Component | License | Link |
|-----------|---------|------|
| Build scripts | MIT | [LICENSE](LICENSE) |
| codex-rs | Apache-2.0 | [codex-oss/LICENSE](codex-oss/LICENSE) |
| Codex.app | Proprietary | [EULA](https://codex.openai.com/) |

## Related Projects

- **Codex (OSS)**: https://github.com/openai/codex
- **Codex.app**: https://codex.openai.com/
- **Electron**: https://www.electronjs.org/
- **Rust**: https://www.rust-lang.org/

## Disclaimer (Again)

⚠️ **This project is UNOFFICIAL and NOT affiliated with OpenAI.**

- No endorsement from OpenAI
- No official support
- Use at your own risk
- Respect Codex.app license and terms
- Community-maintained

By using this project, you agree to the terms in [LEGAL.md](LEGAL.md).

---

**Made with ❤️ by the community**

Questions? See [LEGAL.md](LEGAL.md) or open an issue.
