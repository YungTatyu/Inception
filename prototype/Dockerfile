FROM debian:stable-slim

# Change to non-root privilege
# USER user

RUN apt update && apt install -y --no-install-recommends \
    bash \
    vim \
    curl \
    nginx \
    wget \
    ca-certificates \
    mariadb-server \
    php-fpm \
    php-mysql \
    openssl 

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mkdir -p /var/www/html/ && \
    mv wordpress /var/www/html/ && \
    rm -rf latest.tar.gz; \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x -R /var/www/html/wordpress; \
    chmod +x /usr/bin/entrypoint.sh; \
    chown -R www-data:www-data /var/www/html/wordpress

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

