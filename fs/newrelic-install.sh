#!/bin/sh

APPLICATION_NAME=${1-Undefined}

export NR_INSTALL_SILENT=1
export NR_INSTALL_PHPLIST=/usr/bin
export NR_INSTALL_KEY="${NEWRELIC_LICENSE}"

NEWRELIC_VERSION="7.2.0.191"
cd /tmp
wget -q https://download.newrelic.com/php_agent/release/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz
tar -zxf newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz
cd newrelic-php5-${NEWRELIC_VERSION}-linux-musl
./newrelic-install install

sed -e "s|PHP Application|${APPLICATION_NAME}|g" -i /etc/php7/conf.d/newrelic.ini >/dev/null