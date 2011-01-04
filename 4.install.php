#!/bin/bash
source ${0%/*}/config.sh

echo 编译安装PHP（FastCGI模式）
cd ${build_dir}/${php_pkg}
gzip -cd ${downloads}/${php_fpm_pkg}.diff.gz | patch -d . -p1

./configure --prefix=${php_install} --with-config-file-path=${php_install}/etc --with-mysql=${mysql_install} --with-mysqli=${mysql_install}/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-discard-path --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap
make ZEND_EXTRA_LIBS='-liconv'
make install
cp php.ini-dist ${php_install}/etc/php.ini
cd ../
