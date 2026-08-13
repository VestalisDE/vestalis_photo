#!/bin/sh
set -e

export SCRIPT_NAME=/ping-fpm
export SCRIPT_FILENAME=/ping-fpm
export REQUEST_METHOD=GET

if ! wget -O /dev/null http://127.0.0.1:8080/nginx-health; then
	exit 1
fi

if ! cgi-fcgi -bind -connect /tmp/php-fpm.sock; then
	exit 1
fi
