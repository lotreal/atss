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
    local package=$cache_dir/$(xpackage $i)
    if [ -s $package ]; then
      echo "$package [found]"
    else
      echo "Error: $package not found!!!download now......"
      wget $i -P $cache_dir/
      xcheck "下载 $package" $?
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
