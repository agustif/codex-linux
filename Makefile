.PHONY: all build quick full clean dev shell release deb appimage tarball help ci-build

# Default target
all: quick

# Quick build (x86_64 + arm64, Ubuntu only) - for PRs/testing
quick:
	@echo "🚀 Quick build (x86_64 + arm64, Ubuntu only)"
	@echo "Run: gh workflow run ci.yml --ref $$(git rev-parse --abbrev-ref HEAD) -f build_mode=quick"
	@./scripts/ci-build.sh latest

# Full build (all archs + distros) - for releases
full:
	@echo "🚀 Full build (all architectures + distributions)"
	@echo "Run: gh workflow run ci.yml --ref $$(git rev-parse --abbrev-ref HEAD) -f build_mode=full"
	@./scripts/ci-build.sh latest

# Local Docker build (legacy, uses docker-compose)
build:
	@echo "Building with Docker Compose..."
	docker-compose -f docker/docker-compose.yml build 2>/dev/null || docker build -f docker/Dockerfile -t codex-build .
	docker run --rm -v $$(pwd):/build codex-build bash /build/docker/build.sh

# Build only .deb package
deb:
	@echo "Building .deb package..."
	docker-compose -f docker/docker-compose.yml run --rm build-deb 2>/dev/null || echo "Use: make build"

# Build only AppImage
appimage:
	@echo "Building AppImage..."
	docker-compose -f docker/docker-compose.yml run --rm build-appimage 2>/dev/null || echo "Use: make build"

# Build tarball
tarball:
	@echo "Building tarball..."
	cd codex-linux-fork && npm run build:tarball 2>/dev/null || echo "Use: make build"

# CI build with Codex.app download
ci-build:
	@./scripts/ci-build.sh

# Release (alias for full)
release: full

# Development shell
shell:
	@echo "Opening shell in build container..."
	docker run -it --rm -v $$(pwd):/build -w /build ubuntu:22.04 bash

# Run locally (Electron wrapper)
dev:
	cd codex-linux-fork && npm install && npm start

# Clean build artifacts
clean:
	@echo "Cleaning..."
	rm -rf release/* codex-linux-fork/dist codex-linux-fork/node_modules target-cache
	docker-compose -f docker/docker-compose.yml down -v 2>/dev/null || true

# Prune Docker caches
prune: clean
	docker system prune -f

# Help
help:
	@echo "Codex Linux Fork - Build System"
	@echo ""
	@echo "🎯 Local Builds:"
	@echo "  make quick      - Quick build locally (x86_64 + arm64)"
	@echo "  make build      - Docker build (legacy)"
	@echo "  make dev        - Run Electron wrapper"
	@echo ""
	@echo "📦 CI/CD Workflows:"
	@echo "  make full       - Trigger full CI (all archs + distros)"
	@echo "  make ci-build   - Manual CI build with Codex.app download"
	@echo ""
	@echo "🧹 Maintenance:"
	@echo "  make clean      - Remove build artifacts"
	@echo "  make prune      - Clean + prune Docker"
	@echo "  make shell      - Interactive build shell"
	@echo ""
	@echo "📍 CI/CD:"
	@echo "  Unified workflow: .github/workflows/ci.yml"
	@echo "  Quick mode (PR): 2 archs × 1 distro"
	@echo "  Full mode (tag): 3 archs × 3+ distros"
