#! /usr/bin/bash

start_services() {
  # need this to use rc-service
  openrc
  touch /run/openrc/softlevel
  #rc-service nginx start
  #rc-service php-fpm83 start
  #rc-service mariadb start
  rc-update add nginx default
  rc-update add php-fpm83 default
  rc-update add mariadb default

}

init_mariadb() {
  mkdir /var/lib/mysql
  chown mysql:mysql /var/lib/mysql

  /etc/init.d/mariadb setup
}

main() {
  echo starting setup
  init_mariadb
  start_services
  echo done init

  return 0
}

main "$@"
