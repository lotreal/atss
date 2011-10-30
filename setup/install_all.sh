#!/bin/bash
. h.sh

download_all

xinstall profile
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
