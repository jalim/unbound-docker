# unbound-docker

A Docker container for running Unbound DNS server on Alpine Linux.

## Features

- 🏔️ Based on Alpine Linux (minimal size)
- 🔒 Secure DNS resolution with DNSSEC support
- 🚀 Automated builds via GitHub Actions
- 📦 Published to GitHub Container Registry
- ✅ Built-in health checks
- 🏗️ Multi-architecture support (amd64 and arm64)

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
- Access control allowing all clients (⚠️ **restrict in production!**)
- IPv4 and IPv6 support

### Security Considerations

⚠️ **Important**: The default configuration allows DNS queries from any IP address. For production deployments, you should restrict access to specific networks by modifying the `access-control` settings in `unbound.conf`:

```conf
# Example: Allow only specific networks
access-control: 192.168.0.0/16 allow
access-control: 10.0.0.0/8 allow
access-control: 172.16.0.0/12 allow
```

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

- **On push to main/master**: Automatically analyzes commits and creates semantic version releases
- **On pull request**: Builds but doesn't push (validation only)
- **Manual dispatch**: Allows manual triggering of builds

### Semantic Versioning

This project uses [Semantic Versioning](https://semver.org/) (semver) for all releases. Versions are automatically determined based on commit messages following the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New features trigger a **MINOR** version bump (e.g., 1.0.0 → 1.1.0)
- `fix:` - Bug fixes trigger a **PATCH** version bump (e.g., 1.0.0 → 1.0.1)
- `BREAKING CHANGE:` - Breaking changes trigger a **MAJOR** version bump (e.g., 1.0.0 → 2.0.0)
- `docs:`, `refactor:`, `perf:` - Also trigger PATCH version bumps
- `chore:`, `test:`, `ci:`, `build:` - Do not trigger releases

#### Example Commit Messages

```bash
# Minor version bump (new feature)
feat: add support for custom DNS forwarders

# Patch version bump (bug fix)
fix: correct health check timeout issue

# Major version bump (breaking change)
feat!: change default port from 53 to 5353

BREAKING CHANGE: Default DNS port changed to 5353
```

#### Docker Image Tags

Each release automatically creates multiple Docker image tags:
- `latest` - Always points to the most recent release
- `X.Y.Z` - Specific version (e.g., `1.2.3`)
- `X.Y` - Minor version (e.g., `1.2`)
- `X` - Major version (e.g., `1`)

Example:
```bash
# Pull specific version
docker pull ghcr.io/jalim/unbound-docker:1.2.3

# Pull latest minor version
docker pull ghcr.io/jalim/unbound-docker:1.2

# Pull latest major version
docker pull ghcr.io/jalim/unbound-docker:1

# Pull latest release
docker pull ghcr.io/jalim/unbound-docker:latest
```

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
