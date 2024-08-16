#! /usr/bin/bash

start_services() {
  return 0
}

init_mariadb() {
  mariadb -e "CREATE DATABASE wordpress;"
  mariadb -e "CREATE USER 'wp'@'%' IDENTIFIED BY 'wp';"
  mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp'@'%';"
  mariadb -e "FLUSH PRIVILEGES;"
  return 0
}

main() {
  init_mariadb
  start_services

  return 0
}

main "$@"
