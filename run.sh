#!/bin/sh

if [ -f "/opt/fpm/bootstrap.sh" ]
then
    chmod +x /opt/fpm/bootstrap.sh
    ./opt/fpm/bootstrap.sh
fi

exec php-fpm7 --nodaemonize