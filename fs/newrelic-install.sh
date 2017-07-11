#!/bin/sh

APPLICATION_NAME=${1-Undefined}

export NR_INSTALL_SILENT=1
export NR_INSTALL_PHPLIST=/usr/bin
export NR_INSTALL_KEY="${NEWRELIC_LICENSE}"

NEWRELIC_VERSION="7.4.0.198"
cd /tmp
wget -q https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz
tar -zxf newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz
cd newrelic-php5-${NEWRELIC_VERSION}-linux-musl
./newrelic-install install

sed -e "s|PHP Application|${APPLICATION_NAME}|g" -i /etc/php7/conf.d/newrelic.ini >/dev/null
