# Contributing to unbound-docker

Thank you for your interest in contributing to unbound-docker! This document provides guidelines for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/unbound-docker.git`
3. Create a new branch: `git checkout -b your-feature-branch`
4. Make your changes
5. Test your changes locally
6. Commit your changes following our commit message conventions
7. Push to your fork and submit a pull request

## Commit Message Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/) to automate versioning and changelog generation. Please follow these guidelines when writing commit messages:

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: A new feature (triggers MINOR version bump)
- **fix**: A bug fix (triggers PATCH version bump)
- **docs**: Documentation changes (triggers PATCH version bump)
- **refactor**: Code refactoring without changing functionality (triggers PATCH version bump)
- **perf**: Performance improvements (triggers PATCH version bump)
- **test**: Adding or updating tests (no version bump)
- **chore**: Maintenance tasks, dependency updates (no version bump)
- **ci**: CI/CD changes (no version bump)
- **build**: Build system changes (no version bump)

### Breaking Changes

To indicate a breaking change, add `!` after the type or include `BREAKING CHANGE:` in the footer:

```bash
feat!: change default DNS port to 5353

BREAKING CHANGE: The default DNS port has been changed from 53 to 5353.
Users must update their port mappings when upgrading.
```

### Examples

#### Feature Addition
```bash
feat: add support for custom DNS forwarders

This adds the ability to configure custom DNS forwarders through
environment variables.
```

#### Bug Fix
```bash
fix: correct health check timeout issue

The health check was timing out too quickly on slower systems.
Increased the timeout from 3s to 5s.
```

#### Documentation Update
```bash
docs: update README with Docker Compose example

Added a complete Docker Compose example with health checks.
```

#### Refactoring
```bash
refactor: simplify Dockerfile layer structure

Consolidated RUN commands to reduce image layers and improve build cache efficiency.
```

#### Chore (no release)
```bash
chore: update dependencies

Updated base Alpine image to latest version.
```

## Testing Your Changes

Before submitting a pull request:

1. **Build the Docker image locally:**
   ```bash
   docker build -t unbound-docker:test .
   ```

2. **Test the container:**
   ```bash
   docker run -d --name unbound-test -p 5353:53/tcp -p 5353:53/udp unbound-docker:test
   ```

3. **Verify DNS resolution:**
   ```bash
   dig @localhost -p 5353 google.com
   ```

4. **Check container health:**
   ```bash
   docker ps
   docker inspect --format='{{.State.Health.Status}}' unbound-test
   ```

5. **Clean up:**
   ```bash
   docker stop unbound-test
   docker rm unbound-test
   ```

## Pull Request Guidelines

- Keep pull requests focused on a single change or feature
- Write clear commit messages following our conventions
- Update documentation if your changes affect usage
- Ensure the Docker image builds successfully
- Test your changes thoroughly before submitting

## Automated Releases

When your pull request is merged to the `main` branch:

1. The CI/CD pipeline analyzes your commit messages
2. It determines the appropriate version bump based on commit types
3. It creates a new Git tag with the version number
4. It generates a CHANGELOG.md entry
5. It builds and publishes Docker images with appropriate tags
6. It creates a GitHub release with release notes

You don't need to manually create tags or releases!

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.

## License

By contributing to unbound-docker, you agree that your contributions will be licensed under the MIT License.
