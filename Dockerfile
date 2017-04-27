FROM alpine:edge

ENV COMPOSER_VERSION=1.4.1
ENV XDEBUG_VERSION=2.5.3
ENV BUILD_DEPS autoconf make g++ gcc

COPY ./docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # Required deps
    && apk add --update \
    php7 php7-ctype php7-curl php7-json php7-mysqli php7-dom \
    php7-mbstring php7-opcache php7-openssl php7-pdo_mysql php7-pdo_sqlite \
    php7-xmlwriter php7-phar php7-session php7-xml php7-mcrypt \
    php7-zip php7-zlib php7-fpm php7-dev php7-pear php7-memcached \
    wget curl \

    # Build deps
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \

    # XDebug
    && cd /tmp && wget http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz \
    && tar -zxvf xdebug-${XDEBUG_VERSION}.tgz \
    && cd xdebug-${XDEBUG_VERSION} && phpize \
    && ./configure --enable-xdebug && make && make install \
    && cd \
    && rm -rf /tmp/* \

    # Composer
    && curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && composer global require "hirak/prestissimo:0.3.5" \

    # Remove build deps
    && rm -rf /var/cache/apk/* \
    && apk del .build-deps \

    && chmod +x /usr/sbin/docker-entrypoint.sh

ADD fs /

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000

WORKDIR /app