#!/bin/bash
source $meta/php.ini
source $meta/mysql.ini

apply_php_fpm()
{
    gzip -cd $cache_dir/$(xpackage $php_fpm) | patch -d . -p1
}

xprepare $php

php_version_install=$sys_install/$CURRENT_PACKAGE

xcheck "应用 php_fpm 补丁" "apply_php_fpm"

./configure \
    --prefix=${php_version_install} \
    --with-config-file-path=${php_version_install}/etc \
    --with-mysql=${mysql_install} \
    --with-mysqli=${mysql_install}/bin/mysql_config \
    --with-iconv-dir=/usr/local \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-ftp \
    --with-zlib \
    --with-libxml-dir=/usr \
    --enable-xml \
    --disable-rpath \
    --enable-discard-path \
    --enable-safe-mode \
    --enable-bcmath \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --with-curl \
    --with-curlwrappers \
    --enable-mbregex \
    --enable-fastcgi \
    --enable-fpm \
    --enable-force-cgi-redirect \
    --enable-mbstring \
    --with-mcrypt \
    --with-gd \
    --enable-gd-native-ttf \
    --with-openssl \
    --with-mhash \
    --enable-pcntl \
    --enable-sockets \
    --with-ldap \
    --with-ldap-sasl \
    --with-xmlrpc \
    --enable-zip \
    --enable-soap

xcheck "./configure" $?

xcheck "make ZEND_EXTRA_LIBS='-liconv'"
xcheck "make install"

xautosave $php_install
xcheck "ln -s $php_version_install $php_install"

cp php.ini-recommended $php_install/etc

cd ext/ftp/
$php_install/bin/phpize
./configure --with-php-config=$php_install/bin/php-config
make
make install
