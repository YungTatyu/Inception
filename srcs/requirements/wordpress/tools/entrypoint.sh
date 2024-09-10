#! /bin/bash

readonly WP_PATH='/var/www/html/wordpress'

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

setup_wordpress() {
 if [[ -e /var/www/html/wordpress/wp-config.php ]]; then
   return 0
 fi
 cd ${WP_PATH} && wp config create --dbname=${MARIADB_NAME} --dbuser=${MARIADB_USER} --dbpass=${MARIADB_PASSWORD} --dbhost=mariadb --path=${WP_PATH} --allow-root || return 1
 wp core install --allow-root --path=${WP_PATH} --title=${WP_TITLE} --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --url=https://${DOMAIN_NAME} || return 1
 wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} --role=subscriber --user_pass=${WP_USER_PASSWORD} --allow-root --path=${WP_PATH} || return 1
return 0
}

# need this or fail to start php-fpm
setup_phpfpm() {
  service php7.4-fpm start 
  service php7.4-fpm stop 
  return 0
}

main() {
  setup_wordpress || { err "failed to setup wordpress"; return 1; }
  setup_phpfpm
  php-fpm7.4 -F || { err "failed to start php-fpm"; return 1; }
  return 0
}

main "$@"
