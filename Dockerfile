FROM alpine:3.22

# Install Unbound DNS server
RUN apk update && apk add --no-cache unbound dns-root-hints bind-tools

# Create necessary directories
RUN mkdir -p /opt/unbound/etc/unbound/

# Copy configuration file
COPY unbound.conf /opt/unbound/etc/unbound/unbound.conf

# Expose DNS port
EXPOSE 53/tcp
EXPOSE 53/udp

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD dig @127.0.0.1 cloudflare.com +short || exit 1

# Run Unbound in foreground
CMD ["unbound", "-d", "-c", "/opt/unbound/etc/unbound/unbound.conf"]
