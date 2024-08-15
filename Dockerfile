FROM debian:stable-slim

# Change to non-root privilege
# USER user

RUN apt update && apt install -y --no-install-recommends \
    systemd \
    bash \
    vim \
    curl \
    nginx \
    wget \
    ca-certificates \
    mariadb-server \
    php-fpm

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mkdir -p /var/www/html/ && \
    mv wordpress /var/www/html/ && \
    rm -rf wordpress latest.tar.gz

RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY init.sh /usr/bin/init.sh

RUN bash /usr/bin/init.sh

CMD ["/usr/bin/systemd"]

