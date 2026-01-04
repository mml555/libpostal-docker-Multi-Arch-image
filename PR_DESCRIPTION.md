# Add Docker README Section

This PR adds a section to the libpostal README linking to the community-maintained multi-architecture Docker image.

## What this adds

A "Docker" section in the README pointing users to [mml555/libpostal-docker](https://github.com/mml555/libpostal-docker), which provides:

- **Multi-architecture support**: `linux/amd64` and `linux/arm64` (Apple Silicon, AWS Graviton, Oracle Ampere)
- **HTTP API**: Simple REST endpoints for parsing and normalization
- **Pre-built images**: Available on both GitHub Container Registry and Docker Hub
- **Automated builds**: GitHub Actions CI/CD for continuous updates

## Why this is useful

1. **Solves ARM64 issues** - Several issues mention ARM64 build problems (#690, #593). This image handles architecture detection and disables SSE2 automatically on ARM.

2. **Reduces setup friction** - No need to compile from source or download 2GB of data manually. Just `docker run`.

3. **Production-ready** - Includes health checks, graceful shutdown, and Gunicorn for production use.

## Proposed README addition

```markdown
## Docker

A community-maintained multi-architecture Docker image is available:

\`\`\`bash
# GitHub Container Registry
docker run -d -p 4400:4400 ghcr.io/mml555/libpostal-docker:latest

# Docker Hub
docker run -d -p 4400:4400 mml555/libpostal:latest
\`\`\`

This provides HTTP endpoints for parsing (`/parser`) and normalization (`/expand`).
See [mml555/libpostal-docker](https://github.com/mml555/libpostal-docker) for full documentation.
```

## Related Issues

- #690 - Latest master not building on arm64 - segfault
- #593 - Build error 123 while building docker image
