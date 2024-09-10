FROM debian:bullseye-slim

RUN apt update && apt install -y --no-install-recommends \
    bash \
    mariadb-server; \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG MARIADB_ROOT_PASSWORD \
    MARIADB_NAME \
    MARIADB_USER \
    MARIADB_PASSWORD

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/build.sh /usr/bin/build.sh
COPY tools/entrypoint.sh /usr/bin/entrypoint.sh

# need to setup while building a image because db has to be ready when wordpress access to db
RUN chmod +x /usr/bin/build.sh; \
    chmod +x /usr/bin/entrypoint.sh; \
    /usr/bin/build.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

