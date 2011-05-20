#!/bin/bash
. h.sh

download_all() {
  for i in \
    "$bitlbee" \
    "$php_libiconv" \
    "$php_libmhash" \
    "$php_libmcrypt" \
    "$mcrypt" \
    "$cmake" \
    "$mysql" \
    "$php" \
    "$php_fpm" \
    "$php5_3" \
    "$eaccelerator" \
    "$imagemagick" \
    "$pecl_memcache" \
    "$pecl_pdo_mysql" \
    "$pecl_imagick" \
    "$zend_optimizer" \
    "$pcre" \
    "$nginx" \
    "$phpmyadmin"
  do
    if [ -s $cache_dir/$i ]; then
      echo "$i [found]"
    else
      echo "Error: $i not found!!!download now......"
      echo wget $i -P $cache_dir/
    fi
  done
}
download_all

xinstall bitlbee
xinstall php_libiconv
xinstall php_libmhash
xinstall php_libmcrypt

xinstall mcrypt
xinstall cmake

xinstall mysql

xinstall php --dont-config
xinstall eaccelerator
xinstall imagemagick
xinstall pecl_imagick
xinstall pecl_memcache
xinstall pecl_pdo_mysql
xinstall php --config-only

xinstall nginx
xinstall phpmyadmin

xinstall vsftpd

. tuning/network.sh
. tuning/tuning.sh
. tuning/mysql.sh
. tuning/rclocal.sh
