# unbound-docker

A Docker container for running Unbound DNS server on Alpine Linux.

## Features

- 🏔️ Based on Alpine Linux (minimal size)
- 🔒 Secure DNS resolution with DNSSEC support
- 🚀 Automated builds via GitHub Actions
- 📦 Published to GitHub Container Registry
- ✅ Built-in health checks

## Quick Start

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/jalim/unbound-docker:latest
```

### Run the Container

```bash
docker run -d \
  --name unbound \
  -p 53:53/tcp \
  -p 53:53/udp \
  ghcr.io/jalim/unbound-docker:latest
```

### Test DNS Resolution

```bash
# Test with dig
dig @localhost google.com

# Test with nslookup
nslookup google.com localhost

# Test with drill (if available)
drill @localhost cloudflare.com
```

## Building Locally

### Build the Image

```bash
docker build -t unbound-docker .
```

### Run Locally Built Image

```bash
docker run -d \
  --name unbound \
  -p 53:53/tcp \
  -p 53:53/udp \
  unbound-docker
```

## Configuration

The default configuration is located in `unbound.conf` and includes:

- DNS resolution on port 53 (TCP/UDP)
- DNSSEC validation enabled
- Query caching for improved performance
- Access control allowing all clients
- IPv4 and IPv6 support

### Custom Configuration

To use a custom configuration file:

```bash
docker run -d \
  --name unbound \
  -p 53:53/tcp \
  -p 53:53/udp \
  -v /path/to/your/unbound.conf:/opt/unbound/etc/unbound/unbound.conf:ro \
  ghcr.io/jalim/unbound-docker:latest
```

## Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  unbound:
    image: ghcr.io/jalim/unbound-docker:latest
    container_name: unbound
    ports:
      - "53:53/tcp"
      - "53:53/udp"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "drill", "@127.0.0.1", "cloudflare.com"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```

Run with:

```bash
docker-compose up -d
```

## Health Check

The container includes a built-in health check that queries `cloudflare.com` every 30 seconds to ensure Unbound is functioning correctly.

Check container health:

```bash
docker ps
docker inspect --format='{{.State.Health.Status}}' unbound
```

## Automated Builds

This repository uses GitHub Actions to automatically build and push Docker images to GitHub Container Registry:

- **On push to main/master**: Builds and pushes with `latest` tag
- **On tag (v*)**: Builds and pushes with version tags
- **On pull request**: Builds but doesn't push

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
