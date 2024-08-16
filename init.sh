#! /usr/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

start_service() {
  local service=$1
  local timeout=$2
  local start_time=$(date +%s) #time in seconds sicne epoch
 
  systemctl start ${service} || return 1
  while ! systemctl status ${service}; do
    echo "waiting ${service} to start"
    sleep 0.5
    local cur_time=$(date +%s)
    if (( cur_time - start_time > timeout )); then
      err "${service} failed to start"
      return 1
    fi
  done

  return 0
}

stop_service() {
  local service=$1
  systemctl stop ${service}
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
  start_service mariadb 5
  init_mariadb
  stop_service mariadb

  return 0
}

main "$@"
