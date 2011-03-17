#!/bin/bash
source h.sh
xinstall bitlbee
xinstall php_libiconv
xinstall php_libmhash
xinstall php_libmcrypt

xinstall mcrypt
xinstall cmake
# config make mysql install pause for waiting password
xinstall mysql --dont-config

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

xinstall final

xinstall mysql --config-only