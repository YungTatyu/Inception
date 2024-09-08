#! /usr/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

start_service() {
  local timeout=$1
  local start_time=$(date +%s) #time in seconds sicne epoch

  service mariadb start || return 1
  # wait till mariadb is ready
  while ! mysqladmin ping --silent; do
    sleep 0.5
    local cur_time=$(date +%s)
    if ((cur_time - start_time > timeout)); then
      return 1
    fi
  done

  return 0
}

setup_mariadb() {
  if [ ! -e /var/log/mysql ]; then
    mkdir -m 2750 /var/log/mysql
    chown mysql /var/log/mysql
  fi
  mariadb -e "
    -- データベースが存在しない場合のみ作成
    CREATE DATABASE IF NOT EXISTS ${MARIADB_NAME};

    -- ユーザーが存在しない場合のみ作成
    CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_USER}';
    
    -- ユーザーに権限を付与
    GRANT ALL PRIVILEGES ON ${MARIADB_NAME}.* TO '${MARIADB_USER}'@'%';
    
    -- 変更を有効化
    FLUSH PRIVILEGES;
  " || { err "failed to setup mariadb"; return 1; }
  return 0
}

main() {
  start_service 10 || { err "failed to start mariadb"; return 1; }
  setup_mariadb || return 1
  service mariadb stop
  return 0
}

main "$@"
