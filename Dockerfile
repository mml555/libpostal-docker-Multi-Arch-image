FROM python:3.11-bookworm

LABEL org.opencontainers.image.source="https://github.com/mml555/libpostal-docker"
LABEL org.opencontainers.image.description="Multi-arch libpostal HTTP service"
LABEL org.opencontainers.image.licenses="MIT"

# Install build dependencies for libpostal
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    autoconf \
    automake \
    libtool \
    pkg-config \
    gcc \
    g++ \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone and build libpostal from source (ARM64 compatible)
WORKDIR /tmp
RUN git clone https://github.com/openvenues/libpostal.git && \
    cd libpostal && \
    ./bootstrap.sh && \
    # Detect architecture and disable SSE2 for ARM
    if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then \
    ./configure --datadir=/usr/share/libpostal --disable-sse2; \
    else \
    ./configure --datadir=/usr/share/libpostal; \
    fi && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    # Clean up source to save space
    cd .. && rm -rf libpostal

# Download libpostal data (~2GB)
RUN libpostal_data download all /usr/share/libpostal

# Install Python bindings and Flask
RUN pip install --no-cache-dir postal flask gunicorn

# Create the HTTP service
WORKDIR /app
COPY server.py .

EXPOSE 4400

# Health check
HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --retries=10 \
    CMD curl -f http://localhost:4400/health || exit 1

CMD ["gunicorn", "-b", "0.0.0.0:4400", "-w", "1", "--timeout", "30", "server:app"]
