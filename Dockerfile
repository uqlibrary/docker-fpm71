FROM uqlibrary/centos:191030

ENV COMPOSER_VERSION=1.6.5

RUN \
  rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm && \
  #Enable the ius testing and disable mirrors to ensure getting latest, not an out of date mirror
  sed -i "s/mirrorlist/#mirrorlist/" /etc/yum.repos.d/ius-testing.repo && \
  sed -i "s/#baseurl/baseurl/" /etc/yum.repos.d/ius-testing.repo

RUN \
  yum update -y && \
  yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
  yum --enablerepo=remi-test install -y \
    php71-php-common \
    php71-php-cli \
    php71-php-fpm \
    php71-php-gd \
    php71-php-imap \
    php71-php-ldap \
    php71-php-mcrypt \
    php71-php-mysqlnd \
    php71-php-pdo \
    php71-php-pecl-geoip \
    php71-php-pecl-memcached \
    php71-php-pecl-xdebug \
    php71-php-pecl-zip \
    php71-php-intl \
    php71-php-pgsql \
    php71-php-soap \
    php71-php-xmlrpc \
    php71-php-mbstring \
    php71-php-tidy \
    php71-php-opcache \
    git \
    newrelic-php5 \
    newrelic-sysmond \
    mysql \
    which && \
  yum clean all

COPY etc/php-fpm.d/www.conf /etc/opt/remi/php71/php-fpm.d/www.conf
COPY etc/php.d/15-xdebug.ini /etc/opt/remi/php71/php.d/15-xdebug.ini

RUN \
  rm -f /etc/opt/remi/php71/php.d/20-mssql.ini && \
  rm -f /etc/opt/remi/php71/php.d/30-pdo_dblib.ini && \
  sed -i "s/;date.timezone =.*/date.timezone = Australia\/Brisbane/" /etc/opt/remi/php71/php.ini && \
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/opt/remi/php71/php.ini && \
  sed -i "s/display_errors =.*/display_errors = Off/" /etc/opt/remi/php71/php.ini && \
  sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/opt/remi/php71/php.ini && \
  sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/opt/remi/php71/php-fpm.conf && \
  sed -i "s/error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/opt/remi/php71/php-fpm.conf && \
  sed -i "s/;log_level = notice/log_level = warning/" /etc/opt/remi/php71/php-fpm.conf && \
  usermod -u 1000 nobody && \
  ln -s /opt/remi/php71/root/usr/sbin/php-fpm /usr/sbin/php-fpm && \
  ln -s /etc/opt/remi/php71/php.ini /etc/php.ini && \
  mkdir -p /etc/php-fpm.d && \
  ln -s /etc/opt/remi/php71/php-fpm.d/www.conf /etc/php-fpm.d/www.conf && \
  ln -s /etc/opt/remi/php71/php.d /etc/php.d && \
  ln -s /opt/remi/php71/root/bin/php /usr/bin/php && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}

EXPOSE 9000

ENV NSS_SDB_USE_CACHE YES

ENTRYPOINT ["/opt/remi/php71/root/usr/sbin/php-fpm", "--nodaemonize"]​
