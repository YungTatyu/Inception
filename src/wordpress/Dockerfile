FROM debian:stable-slim

RUN apt update && apt install -y --no-install-recommends \
    bash \
    curl \
    ca-certificates \
    php-fpm \
    php-mysql; \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mkdir -p /var/www/html/ && \
    mv wordpress /var/www/html/ && \
    rm -rf latest.tar.gz; \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x -R /var/www/html/wordpress; \
    chmod +x /usr/bin/entrypoint.sh; \
    chown -R www-data:www-data /var/www/html/wordpress

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

