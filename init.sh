#! /usr/bin/bash

start_services() {
  #rc-service nginx start
  #rc-service php-fpm83 start
  #rc-service mariadb start
  # rc-update add nginx default
  # rc-update add php-fpm83 default
  # rc-update add mariadb default
  return 0
}

init_mariadb() {
  # mkdir /var/lib/mysql
  # chown mysql:mysql /var/lib/mysql

  # /etc/init.d/mariadb setup
  return 0
}

main() {
  # init_mariadb
  # start_services

  return 0
}

main "$@"
