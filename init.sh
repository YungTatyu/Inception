#! /usr/bin/bash

init_mariadb() {
  mkdir /var/lib/mysql
  chown mysql:mysql /var/lib/mysql

  mkdir /run/mysqld
  chown mysql:mysql /run/mysqld
}

main() {
  init_mariadb

  return 0
}

main "$@"
