#! /usr/bin/bash

start_services() {
  # need this to use rc-service
  openrc
  touch /run/openrc/softlevel
  rc-service nginx start
  rc-service php-fpm83 start
  rc-service mariadb start
}

init_mariadb() {
  mkdir /var/lib/mysql
  chown mysql:mysql /var/lib/mysql

  /etc/init.d/mariadb setup
}

main() {
  init_mariadb
  start_services

  return 0
}

main "$@"
