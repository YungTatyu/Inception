#! /usr/bin/bash

readonly WP_PATH='/var/www/html/wordpress'

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

setup_wordpress() {
 cd ${WP_PATH} && wp config create --dbname=${MARIADB_NAME} --dbuser=${MARIADB_USER} --dbpass=${MARIADB_PASSWORD} --dbhost=localhost --path=${WP_PATH} --allow-root || return 1
 wp core install --allow-root --path=${WP_PATH} --title=${WP_TITLE} --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --url=${DOMAIN_NAME} || return 1
 wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} --role=subscriber --user_pass=${WP_USER_PASSWORD} --allow-root --path=${WP_PATH} || return 1
return 0
}

main() {
  setup_wordpress || return 1

  bash
  return 0
}

main "$@"
