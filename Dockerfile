FROM php:7.1-fpm-alpine

ENV TEMP_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev sqlite-dev libmcrypt-dev g++ make autoconf

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apk update \
    && apk add --no-cache --virtual .temp-deps $TEMP_DEPS \
    && apk add  --no-cache libmemcached libmcrypt curl openssh-client git \
    && docker-php-source extract \
    && pecl install xdebug \
    && docker-php-ext-install mcrypt pdo_mysql pdo_sqlite \
    && docker-php-ext-enable xdebug \
    && docker-php-source delete \
    && git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && docker-php-ext-configure /usr/src/php/ext/memcached --disable-memcached-sasl \
    && docker-php-ext-install /usr/src/php/ext/memcached \
    && rm -rf /usr/src/php/ext/memcached \
    && apk del .temp-deps \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=dbgpproxy" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /tmp/* \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME /var/www

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

WORKDIR /var/www