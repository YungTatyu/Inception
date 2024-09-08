FROM debian:stable-slim

RUN apt update && apt install -y --no-install-recommends \
    bash \
    vim \
    mariadb-server

RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG MARIADB_ROOT_PASSWORD
ARG MARIADB_NAME
ARG MARIADB_USER
ARG MARIADB_PASSWORD

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/build.sh /usr/bin/build.sh

RUN chmod +x /usr/bin/build.sh && /usr/bin/build.sh

ENTRYPOINT ["mariadbd"]

