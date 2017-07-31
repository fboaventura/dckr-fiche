#!/bin/bash
set -eo pipefail

[[ "${DEBUG}" == true ]] && set -x

BASE_DIR=${BASEDIR:-"/usr/local/apache2/htdocs"}
CONF_DIR=${CONFDIR:-"/termbin/confs"}
DOMAIN=${DOMAIN:-"localhost"}
PORT=${PORT:-"9999"}


initialize_system() {
  /usr/local/bin/fiche -6 -d ${DOMAIN} -o ${BASE_DIR} -l /dev/stdout -s 8 -B 2048 -D 
}

start_system() {
  initialize_system
  echo "Starting ${DOMAIN}! ..."
  #/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
  httpd-foreground
}

start_system

exit 0
