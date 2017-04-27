FROM alpine:edge

COPY ./run.sh /opt/run.sh

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk --update add \
        curl \
        zlib \
        php7 \
        php7-bcmath \
        php7-dom \
        php7-ctype \
        php7-curl \
        php7-fileinfo \
        php7-fpm \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-memcached \
        php7-mcrypt \
        php7-mysqlnd \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-phar \
        php7-posix \
        php7-session \
        php7-xdebug \
        php7-xml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-zip \
        php7-zlib \
    && rm -rf /var/cache/apk/* \
    && curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "hirak/prestissimo:^0.3" \
    && chmod +x /opt/run.sh

COPY ./php.ini /etc/php7/conf.d/50-setting.ini
COPY ./php-fpm.conf /etc/php7/php-fpm.conf

EXPOSE 9000

ENTRYPOINT ["/opt/run.sh"]