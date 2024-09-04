#! /usr/bin/bash

readonly WP_PATH='/var/www/html/wordpress'
readonly TLS_PATH="/etc/nginx/tls"

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

init_wordpress() {
 cd ${WP_PATH}
 wp config create --dbname=${MARIADB_NAME} --dbuser=${MARIADB_USER} --dbpass=${MARIADB_PASSWORD} --dbhost=localhost --path=${WP_PATH} --allow-root
 wp core install --allow-root --path=${WP_PATH} --title=${WP_TITLE} --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --url=${DOMAIN_NAME}  
 wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} --role=subscriber --user_pass=${WP_USER_PASSWORD} --allow-root --path=${WP_PATH}
}

generate_certificate() {
  if [[ -e /etc/nginx/tls ]]; then
    return 0
  fi
  mkdir /etc/nginx/tls && openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout "${TLS_PATH}/domain.key" -out "${TLS_PATH}/domain.crt" -subj "/C=js/ST=tokyo/L=tokyo/O=tterao/OU=tterao/CN=tterao.42.fr/emailAddress=nginx@nginx.com" || return 1
  return 0
}

main() {
  generate_certificate
  start_service nginx 0
  start_service mariadb 5 
  start_service php8.2-fpm 0
  init_mariadb
  init_wordpress

  bash
  return 0
}

main "$@"
