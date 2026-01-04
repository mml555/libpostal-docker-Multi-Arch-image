# Contributing

Thank you for your interest in contributing to libpostal-docker!

## Reporting Issues

- Check existing issues before creating a new one
- Include your Docker version and host architecture
- Provide the full error message and steps to reproduce

## Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Test locally with `docker build -t libpostal-test .`
5. Submit a pull request

## Local Development

```bash
# Build the image
docker build -t libpostal-dev .

# Run with volume mount for development
docker run -p 4400:4400 -v $(pwd)/server.py:/app/server.py libpostal-dev

# Test endpoints
curl http://localhost:4400/health
curl -X POST http://localhost:4400/parser -H "Content-Type: application/json" -d '{"text": "123 Main St"}'
curl -X POST http://localhost:4400/expand -H "Content-Type: application/json" -d '{"text": "123 Main St"}'
```

## Code Style

- Python: Follow PEP 8
- Dockerfile: Follow Docker best practices
- Keep the image size minimal
