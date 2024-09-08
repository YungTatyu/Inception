FROM debian:stable-slim

RUN apt update && apt install -y --no-install-recommends \
    bash \
    nginx \
    ca-certificates \
    openssl; \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

