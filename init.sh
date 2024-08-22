#! /usr/bin/bash

readonly WP_PATH='/var/www/html/wordpress'

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

start_service() {
  local service=$1
  local timeout=$2
  local start_time=$(date +%s) #time in seconds sicne epoch

  service ${service} start || return 1
  while ! service ${service} status; do
    echo "waiting ${service} to start"
    sleep 0.5
    local cur_time=$(date +%s)
    if ((cur_time - start_time > timeout)); then
      err "${service} failed to start"
      return 1
    fi
  done

  return 0
}

stop_service() {
  local service=$1
  service ${service} stop
  return 0
}

init_mariadb() {
  if [ ! -e /var/log/mysql ]; then
    mkdir -m 2750 /var/log/mysql
    chown mysql /var/log/mysql
  fi
  mariadb -e "
    -- データベースが存在しない場合のみ作成
    CREATE DATABASE IF NOT EXISTS wordpress;

    -- ユーザーが存在しない場合のみ作成
    CREATE USER IF NOT EXISTS 'wp'@'%' IDENTIFIED BY 'wp';
    
    -- ユーザーに権限を付与
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wp'@'%';
    
    -- 変更を有効化
    FLUSH PRIVILEGES;
  "
  return 0
}

init_wordpress() {
 wp core install --allow-root --path=${WP_PATH} --title='inception' --admin_user='tt' --admin_password='tt' --admin_email='wp@wp.com' --url='localhost'  
 wp user create usr usr@usr.com --role=subscriber --user_pass=usr --allow-root --path=${WP_PATH}
}

main() {
  start_service nginx 0
  start_service php8.2-fpm 0
  start_service mariadb 5 || return 1
  init_mariadb
  init_wordpress
  #stop_service mariadb

  return 0
}

main "$@"
