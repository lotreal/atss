#!/bin/bash
# 配置 php 和 php-fpm
php_ext_dir=$($php_install/bin/php-config --extension-dir 2>/dev/null)
mkdir -p $php_ext_dir

/usr/sbin/groupadd www-data
xcheck "groupadd www-data" $? w
/usr/sbin/useradd -g www-data www-data
xcheck "useradd www-data" $? w


mkdir -p $php_log

php_conf=$php_install/etc/php.ini
xconf $php_install/etc php/php.ini "php_ext_dir zend_cache"
xcheck "创建 $php_install/etc/php.ini" $?

php_fpm_conf=$php_install/etc/php-fpm.conf
php_fpm_pid=$php_install/logs/php-fpm.pid
xconf $php_install/etc php/php-fpm.conf "php_fpm_pid php_fpm_err_log"
xcheck "创建 $php_install/etc/php-fpm.conf" $?


xbin $php_install/bin/php
xbin $php_install/sbin/php-fpm

$php_install/bin/php -v

ulimit -SHn 65535
${php_install}/sbin/php-fpm start
#TODO [____ERROR]  {/root/build/ZendOptimizer-3.3.9-linux-glibc23-i386} /webserver/local/php/sbin/php 启动 失败！错误码: 1
#xcheck "${php_install}/sbin/php 启动" $?
