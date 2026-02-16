# BoxLang Docker Images - AI Agent Instructions

## Project Overview
This repository builds and maintains official Docker images for **BoxLang** - a modern dynamic JVM language. It produces multiple image variants published to [Docker Hub](https://hub.docker.com/r/ortussolutions/boxlang) as `ortussolutions/boxlang`.

**Key Image Types:**
- **CLI Images** (`cli`, `cli-alpine`) - For running BoxLang scripts, CLI apps, schedulers, OS integrations
- **MiniServer Images** (`miniserver`, `miniserver-alpine`) - Lightweight web server for BoxLang applications/APIs
- **MiniServer+Nginx** (`miniserver-nginx`) - Experimental: MiniServer with Nginx reverse proxy

## Architecture & Build System

### Version Management
- [version.json](version.json) - Single source of truth for versions:
  - `BOXLANG_VERSION` - BoxLang runtime version to install (e.g., "1.10.1")
  - `IMAGE_VERSION` - Docker image version/tag (e.g., "1.13.0")
- [bump.sh](bump.sh) - Auto-increments `IMAGE_VERSION` minor version, resets patch to 0
- All Dockerfiles use `ARG BOXLANG_VERSION` and `ARG IMAGE_VERSION` passed at build time

### Directory Structure
```
builds/base/               # All Dockerfile definitions
  JRE21.Dockerfile         # Debian CLI base
  Alpine.JRE21.Dockerfile  # Alpine CLI base
  JRE21.Web.Dockerfile     # Debian MiniServer
  Alpine.JRE21.Web.Dockerfile  # Alpine MiniServer
  JRE21.Web.Nginx.Dockerfile   # MiniServer + Nginx

build/                     # Runtime scripts copied into images
  run.sh                   # Main entrypoint for MiniServer images
  start-services.sh        # Multi-process startup (Nginx + BoxLang)
  util/
    install-bx.sh          # BoxLang installation via install.boxlang.io
    env-secrets-expand.sh  # Docker secrets expansion from _FILE suffix vars
    debian/install-dependencies.sh
    alpine/install-dependencies.sh
    nginx/                 # Nginx configs for reverse proxy setup

test/                      # Test files copied to /app in images
```

### Container Directory Layout
All images follow this structure:
- `/app` - Application root (`APP_DIR`), default WORKDIR, mount your code here
- `/usr/local/bin` - BoxLang binaries (`BIN_DIR`)
- `/usr/local/lib/build` - Runtime scripts (`BUILD_DIR`)
- `/root/.boxlang` - BoxLang home directory (`BOXLANG_HOME`)

## Critical Build Patterns

### Dockerfile Build Args
**All Dockerfiles require two build args:**
```bash
docker build \
  --build-arg BOXLANG_VERSION=$(jq -r '.BOXLANG_VERSION' version.json) \
  --build-arg IMAGE_VERSION=$(jq -r '.IMAGE_VERSION' version.json) \
  -f builds/base/JRE21.Web.Dockerfile \
  -t ortussolutions/boxlang:miniserver .
```

### BoxLang Installation
- [build/util/install-bx.sh](build/util/install-bx.sh) uses the official installer:
  ```bash
  curl -fsSL https://install.boxlang.io | /bin/bash -s -- --without-commandbox
  ```
- Requires `BOXLANG_VERSION` env var - fails fast if missing
- Installs to `/usr/local/bin/boxlang` and creates `~/.boxlang/` home

### User Management & Permissions
- [build/run.sh](build/run.sh) handles dynamic user switching at runtime
- If `USER` env var set (and not current user), creates user with `USER_ID` (default 1001)
- Recursively chowns: `$HOME`, `$APP_DIR`, `$BUILD_DIR`, `$BX_HOME`, `${LIB_DIR}/serverHome`
- Uses `su --preserve-environment` (Debian) or `su -p` (Alpine) to re-exec run.sh as that user
- Default workgroup: `root` (Alpine/container convention)

### Environment Secrets Pattern
[build/util/env-secrets-expand.sh](build/util/env-secrets-expand.sh) runs FIRST in run.sh:
- Expands `ENV_VAR_FILE=/path/to/secret` → reads file, sets `ENV_VAR=<content>`
- Supports Docker secrets: `SECRET=<<SECRET:my-secret>>` → reads `/run/secrets/my-secret`
- **Critical**: Uses `printenv | cut -f1 -d"="` to iterate ALL env vars
  - Can hit OS ARG_MAX limit if container has thousands of env vars
  - Prints "Expanding from _FILE suffix" to stdout during startup

## MiniServer Runtime Configuration

### Standard Environment Variables
Defined in [JRE21.Web.Dockerfile](builds/base/JRE21.Web.Dockerfile):
```dockerfile
ENV DEBUG=false
ENV HOST=0.0.0.0
ENV PORT=8080
ENV MAX_MEMORY=512m
ENV MIN_MEMORY=512m
ENV REWRITES=true
ENV REWRITE_FILE=index.bxm
ENV JAVA_OPTS="-Xmx${MAX_MEMORY} -Xms${MIN_MEMORY} -Djava.awt.headless=true"
ENV HEALTHCHECK_URI="http://127.0.0.1:${PORT}/"
```

### BoxLang-Specific Environment Variables
[build/run.sh](build/run.sh) sets defaults if not provided:
- `BOXLANG_HOME` - BoxLang runtime home (default: `$HOME/.boxlang`)
- `BOXLANG_INSTALL_HOME` - Installation directory (default: `/usr/local/boxlang`)
- `BOXLANG_DEBUG` - Debug mode boolean (set by `DEBUG` env var too)
- `BOXLANG_REWRITES` / `BOXLANG_REWRITE_FILE` - URL rewrite configuration

### BoxLang Config Overrides
Any BoxLang config setting can be overridden via `BOXLANG_` prefixed env vars:
```bash
BOXLANG_DEBUGMODE=true
BOXLANG_PORT=9090
```
See: https://boxlang.ortusbooks.com/getting-started/configuration#environment-variable-substitution

### MiniServer Startup
[build/run.sh](build/run.sh) lines 100-145 construct the launch command:
```bash
boxlang-miniserver \
  ${debugString} \           # --debug if DEBUG=true
  ${rewritesString} \        # --rewrites index.bxm if REWRITES=true
  --host ${HOST} \
  --port ${PORT} \
  --app ${APP_DIR}
```

## MiniServer+Nginx Multi-Process Pattern

[JRE21.Web.Nginx.Dockerfile](builds/base/JRE21.Web.Nginx.Dockerfile) uses:
- CMD: [start-services.sh](build/start-services.sh) instead of run.sh
- Starts Nginx in background, captures PID
- Starts BoxLang in foreground via `exec $BUILD_DIR/run.sh`
- Traps SIGTERM/SIGINT to gracefully shutdown both processes
- Nginx configs: [build/util/nginx/](build/util/nginx/) with self-signed SSL cert generation

**Additional Env Vars:**
- `NGINX_PORT` - Default: 80
- `NGINX_SSL_PORT` - Default: 443

## Health Checks

All MiniServer images include:
```dockerfile
HEALTHCHECK --interval=20s --timeout=30s --retries=15 \
  CMD curl --fail ${HEALTHCHECK_URI} || exit 1
```
- Default checks `http://127.0.0.1:8080/`
- Override via `HEALTHCHECK_URI` env var
- 15 retries × 20s = 5 minute startup tolerance

## Module Installation

Images support pre-installing BoxLang modules via `BOXLANG_MODULES` env var:
```yaml
environment:
  - BOXLANG_MODULES=bx-compat-cfml,bx-esapi,bx-mysql
```
- Processed by `/usr/local/bin/install-bx-module` script
- Comma-separated module names
- Installed to `BOXLANG_HOME` at container startup

## Development Workflows

### Testing Locally
```bash
# Build specific image variant
docker build \
  --build-arg BOXLANG_VERSION=$(jq -r '.BOXLANG_VERSION' version.json) \
  --build-arg IMAGE_VERSION=$(jq -r '.IMAGE_VERSION' version.json) \
  -f builds/base/JRE21.Web.Dockerfile \
  -t test-miniserver .

# Run test container
docker run --rm -p 8080:8080 test-miniserver

# Debug mode with shell
docker run --rm -it -p 8080:8080 \
  -e BOXLANG_DEBUG=true \
  test-miniserver /bin/bash
```

### Version Bumping
```bash
# Auto-increment IMAGE_VERSION minor version
./bump.sh

# Manually edit version.json to change BOXLANG_VERSION
jq '.BOXLANG_VERSION = "1.11.0"' version.json > tmp && mv tmp version.json
```

### Common Test Patterns
[test/](test/) directory contains:
- `index.bxm` - Default rewrite target for MiniServer
- `403.html` - Custom error pages

## Common Pitfalls

1. **Missing Build Args**: All Dockerfiles REQUIRE `--build-arg BOXLANG_VERSION` and `IMAGE_VERSION` - builds fail without them
2. **ARG_MAX Errors**: `env-secrets-expand.sh` can hit "Argument list too long" if thousands of env vars exist (iterates ALL with `printenv`)
3. **Permission Issues**: MiniServer needs write access to `/app` and `$BOXLANG_HOME` - use `USER` env var or mount volumes with correct ownership
4. **Alpine vs Debian**: Alpine uses different package managers and user management commands - separate install scripts in `build/util/alpine/` vs `build/util/debian/`
5. **Port Conflicts**: Default `PORT=8080` inside container - map to different host port if needed (`-p 9090:8080`)
6. **Rewrites**: Default `REWRITE_FILE=index.bxm` - ensure this file exists in `/app` or set `REWRITES=false`

## Image Tagging Strategy

Published tags follow pattern:
- `ortussolutions/boxlang:miniserver` - Latest stable MiniServer (Debian)
- `ortussolutions/boxlang:miniserver-1.10.1` - Specific BoxLang version
- `ortussolutions/boxlang:miniserver-alpine` - Latest Alpine variant
- `ortussolutions/boxlang:miniserver-snapshot` - Development/nightly builds
- `ortussolutions/boxlang:cli` - Latest CLI (no web server)

## External Dependencies

- **Base Images**: `eclipse-temurin:21-jre-noble` (Debian), `eclipse-temurin:21-jre-alpine` (Alpine)
- **BoxLang Installer**: https://install.boxlang.io (curl-based install script)
- **Nginx**: Only in `-nginx` variants, configured as reverse proxy to MiniServer
- **Documentation**: https://boxlang.ortusbooks.com/getting-started/running-boxlang/docker

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Pull requests against `development` branch (NOT `master`)
- Code formatting standards (cfformat, Java style)
- Security vulnerability reporting to security@ortussolutions.com
- Issue tracking in Jira: https://ortussolutions.atlassian.net/browse/BL
