#! /bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

main() {
  mariadbd || { cat /var/log/mysql/error.log >&2;
    err "failed to start mariadb";
    return 1;
  }
  return 0
}

main "$@"
