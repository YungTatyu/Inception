#! /usr/bin/bash

readonly TLS_PATH="/etc/nginx/tls"

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

generate_certificate() {
  if [[ -e /etc/nginx/tls ]]; then
    return 0
  fi
  mkdir /etc/nginx/tls && openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout "${TLS_PATH}/domain.key" -out "${TLS_PATH}/domain.crt" -subj "/C=${CF_COUNTRY_NAME}/ST=${CF_STATE_NAME}/L=${CF_CITY_NAME}/O=${CF_ORG_NAME}/OU=${CF_ORG_UNIT_NAME}/CN=${CF_COMMON_NAME}/emailAddress=${CF_EMAIL}" || { err "failed to generate TLS certificates"; return 1; }
  return 0
}

main() {
  generate_certificate || return 1
  nginx -g 'daemon off;' || { err "failed to start nginx"; return 1; }
  return 0
}

main "$@"
