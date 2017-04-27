#!/bin/sh

if [ -f "/opt2/bootstrap.sh" ]
then
    ./opt2/bootstrap.sh
fi

exec php-fpm7 --nodaemonize