# libpostal-docker

Multi-architecture Docker image for [libpostal](https://github.com/openvenues/libpostal) with an HTTP API.

## Architectures

- `linux/amd64` (x86_64)
- `linux/arm64` (Apple Silicon, AWS Graviton, Oracle Ampere)

## Quick Start

```bash
docker run -d -p 4400:4400 --name libpostal ghcr.io/YOURNAME/libpostal-docker:latest
```

## Usage

### Parse an address

```bash
curl -X POST http://localhost:4400/parser \
  -H "Content-Type: application/json" \
  -d '{"text": "123 Main St, New York, NY 10001"}'
```

**Response:**
```json
[
  {"label": "house_number", "value": "123"},
  {"label": "road", "value": "main st"},
  {"label": "city", "value": "new york"},
  {"label": "state", "value": "ny"},
  {"label": "postcode", "value": "10001"}
]
```

### Health check

```bash
curl http://localhost:4400/health
```

## Docker Compose

```yaml
services:
  libpostal:
    image: ghcr.io/YOURNAME/libpostal-docker:latest
    ports:
      - "4400:4400"
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -sf http://localhost:4400/health || exit 1"]
      interval: 10s
      timeout: 3s
      retries: 5
```

## Building Locally

```bash
# Single architecture
docker build -t libpostal .

# Multi-architecture (requires docker buildx)
docker buildx build --platform linux/amd64,linux/arm64 -t libpostal .
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/parser` | POST | Parse address into components |

## Credits

- [libpostal](https://github.com/openvenues/libpostal) - C library for address parsing
- [pypostal](https://github.com/openvenues/pypostal) - Python bindings

## License

MIT - See [LICENSE](LICENSE)
