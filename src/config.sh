#!/bin/bash
# 安装包地址
bitlbee=http://get.bitlbee.org/src/bitlbee-3.0.1.tar.gz

php_libiconv=http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
php_libmhash="http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz?modtime=1175740843&big_mirror=0"
php_libmcrypt="http://downloads.sourceforge.net/mcrypt/libmcrypt-2.5.8.tar.gz?modtime=1171868460&big_mirror=0"
mcrypt="http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz?modtime=1194463373&big_mirror=0"

cmake=http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz
mysql=http://mirror.services.wisc.edu/mysql/Downloads/MySQL-5.5/mysql-5.5.9.tar.gz

php=http://www.php.net/get/php-5.2.14.tar.gz/from/this/mirror
php_fpm=http://php-fpm.org/downloads/php-5.2.14-fpm-0.5.14.diff.gz
eaccelerator=http://bart.eaccelerator.net/source/0.9.6.1/eaccelerator-0.9.6.1.tar.bz2
imagemagick=http://lnmpp.googlecode.com/files/ImageMagick.tar.gz
pecl_memcache=http://pecl.php.net/get/memcache-2.2.5.tgz
pecl_pdo_mysql=http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz
pecl_imagick=http://pecl.php.net/get/imagick-2.3.0.tgz
zend_optimizer=http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz

pcre=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.10.tar.gz
nginx=http://nginx.org/download/nginx-0.8.54.tar.gz

phpmyadmin_url=http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.3.9/phpMyAdmin-3.3.9-all-languages.tar.gz

# 本地设置路径
local_settings=$swd/local_settings/hj

# 服务器路径配置
sys_path=/webserver/bin
sys_install=/webserver/local
sys_conf=/webserver/etc
sys_log=/webserver/log
sys_cache=/webserver/cache

sys_data=/data
sys_backup=$sys_data/.backup
auto_backup=$sys_backup/autosave

# mysql 配置
mysql_install=$sys_install/mysql
mysql_server=/etc/init.d/mysql.server

mysql_port=3306
mysql_sock=/tmp/mysqld.sock

mysql_data=$sys_data/mysql/${mysql_port}/data
mysql_pid=$mysql_data/mysql.pid

mysql_log=$sys_log/mysql/${mysql_port}
mysql_error_log=${mysql_log}/mysql_error.log
mysql_bin_log=${mysql_log}/binlog
mysql_relay_log=${mysql_log}/relaylog
mysql_slow_log=${mysql_log}/slowlog

# php 配置
php_install=$sys_install/php
zend_cache=$sys_cache/zend
php_fpm_pid=$sys_log/php/php-fpm.pid
php_fpm_err_log=$sys_log/php/php-fpm.log

# nginx 配置
nginx_install=$sys_install/nginx
nginx_log=$sys_log/nginx
www=$src_data/www
