.PHONY: all build clean dev shell release deb appimage tarball help ci-build

# Default target
all: build

# Build everything in Docker
build:
	@echo "Building Codex Linux Fork..."
	docker-compose -f docker/docker-compose.yml build
	docker-compose -f docker/docker-compose.yml run --rm build

# Build only .deb package
deb:
	@echo "Building .deb package..."
	docker-compose -f docker/docker-compose.yml run --rm build-deb

# Build only AppImage
appimage:
	@echo "Building AppImage..."
	docker-compose -f docker/docker-compose.yml run --rm build-appimage

# Build tarball
tarball:
	@echo "Building tarball..."
	docker-compose -f docker/docker-compose.yml run --rm build /bin/bash -c "/build/build.sh && cd codex-linux-fork && npm run build:tarball && cp dist/*.tar.gz /output/"

# Full release (all formats)
release: build
	@echo "Release complete. Check ./release/ directory"

# CI build with Codex.app download
ci-build:
	@./scripts/ci-build.sh

# Development shell
shell:
	docker-compose -f docker/docker-compose.yml run --rm dev

# Run directly (for testing)
dev:
	cd codex-linux-fork && npm start

# Clean build artifacts
clean:
	rm -rf release/*
	rm -rf codex-linux-fork/dist
	rm -rf codex-linux-fork/node_modules
	docker-compose -f docker/docker-compose.yml down -v 2>/dev/null || true

# Prune Docker caches
prune: clean
	docker system prune -f

# Help
help:
	@echo "Codex Linux Fork - Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make build     - Build all packages (.deb, AppImage, tarball)"
	@echo "  make deb       - Build only .deb package"
	@echo "  make appimage  - Build only AppImage"
	@echo "  make tarball   - Build only tar.gz"
	@echo "  make release   - Same as build"
	@echo "  make ci-build  - CI build (downloads Codex.app, builds release)"
	@echo "  make shell     - Open a shell in the build container"
	@echo "  make dev       - Run locally (requires Linux)"
	@echo "  make clean     - Remove build artifacts"
	@echo "  make prune     - Clean + prune Docker caches"
	@echo ""
	@echo "Outputs are placed in ./release/"
	@echo ""
	@echo "CI/CD:"
	@echo "  GitHub Actions workflow: .github/workflows/build-linux.yml"
	@echo "  Automatically downloads Codex.app and builds on tag push"
