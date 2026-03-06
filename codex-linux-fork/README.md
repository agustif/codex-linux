# Codex Linux Fork

A community-maintained Linux fork of OpenAI's Codex desktop application, built from the open-source components.

## What This Is

This fork combines:
- **Electron UI**: Extracted from the macOS Codex.app (cross-platform JavaScript)
- **Rust Backend**: Built from the open-source [openai/codex](https://github.com/openai/codex) repository
- **Native Modules**: Rebuilt for Linux (node-pty, better-sqlite3)

## Prerequisites

- Linux (x86_64 or ARM64)
- Node.js 18+
- Rust toolchain (for building the binary)
- Build essentials (gcc, make, etc.)

## Quick Start

```bash
# Clone or copy this fork
cd codex-linux-fork

# Make build script executable
chmod +x build.sh

# Run the build script
./build.sh

# Start the app
npm start
```

## Build from Source

### 1. Build the Rust Binary

```bash
# From the OSS repository
cd codex-oss/codex-rs
cargo build --release -p codex-app-server

# Copy to fork
cp target/release/codex-app-server ../../codex-linux-fork/bin/codex
```

### 2. Install Dependencies

```bash
cd codex-linux-fork
npm install
npm run rebuild  # Rebuild native modules for Linux
```

### 3. Build Packages

```bash
# Build all formats
npm run build:linux

# Or specific formats
npm run build:deb        # .deb package
npm run build:appimage   # AppImage (portable)
npm run build:tarball    # tar.gz archive
```

## Custom API Endpoints

The Rust backend supports custom providers via `~/.codex/config.toml`:

```toml
model_provider = "custom"

[model_providers.custom]
name = "My Custom API"
base_url = "https://my-api.example.com/v1"
env_key = "CUSTOM_API_KEY"
wire_api = "responses"
requires_openai_auth = false
```

Set the environment variable:
```bash
export CUSTOM_API_KEY="your-key-here"
```

## Architecture

```
codex-linux-fork/
├── main.js              # Electron main process
├── preload.js           # Context bridge for IPC
├── webview/             # React UI (from app.asar)
├── bin/codex            # Rust backend (from OSS)
├── resources/rg         # ripgrep for file search
└── package.json         # Dependencies & build config
```

## JSON-RPC Protocol

The UI communicates with the Rust backend via JSON-RPC over WebSocket. Key methods:

- `initialize` - Start session
- `thread/start` - Create conversation thread
- `turn/start` - Send message to AI
- `turn/interrupt` - Cancel current operation
- `model/list` - List available models
- `config/read` - Read configuration

Protocol source: `codex-oss/codex-rs/app-server-protocol/`

## Limitations

- No auto-update (Sparkle is macOS-only)
- Some macOS-specific features removed
- First-run requires accepting permissions

## License

- UI components: OpenAI's license (check original app)
- Rust backend: Apache-2.0 (from openai/codex)
- This fork: MIT for glue code

## Disclaimer

This is an unofficial community fork. Not affiliated with OpenAI. Use at your own risk.
