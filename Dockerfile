FROM alpine:latest

# Change to non-root privilege
# USER user

RUN apk update && apk add --no-cache \
    openrc \
    bash \
    vim \
    curl \
    nginx \
    networkmanager

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mkdir -p /var/www/html/ && \
    mv /wordpress/ /var/www/html/

RUN apk add --no-cache \
    mariadb \
    php-fpm

COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php83/php-fpm.d/www.conf
COPY init.sh /usr/bin/init.sh

RUN bash /usr/bin/init.sh

CMD ["/sbin/init"]

