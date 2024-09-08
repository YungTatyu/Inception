#! /usr/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
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
  service mariadb start || { err "failed to start mariadb"; return 1; }
  setup_mariadb || return 1
  mariadb || { err "failed to access mariadb"; return 1; }
  return 0
}

main "$@"
