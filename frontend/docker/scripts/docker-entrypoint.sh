#!/bin/sh
set -e

if [ "$1" = 'nginx' ]; then
  exec /init
fi

if [ "$1" = 'php-fpm' ]; then
  exec /init
fi

if [ "$1" = 'symfony-cmd' ]; then
  echo "[docker-entrypoint] - Starting symfony command '$2'"
  exec /init php bin/console $2
fi

if [ "$(whoami)" = "root" ]; then
  su-exec bootstrap_user "$@"
else
  exec "$@"
fi
