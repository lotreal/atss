#!/bin/bash
source $ATSS_SETUP_CFG/php.ini

mkdir -p $php_ext_dir
mkdir -p $php_log

/usr/sbin/groupadd www-data
xcheck "groupadd www-data" $? w
/usr/sbin/useradd -g www-data www-data
xcheck "useradd www-data" $? w


PHP_INI=$sys_conf/php/php.ini
cp $php_install/etc/php.ini-recommended $PHP_INI

sed -i 's#extension_dir = "./"#extension_dir = "${php_ext_dir}"\nextension = "memcache.so"\nextension = "pdo_mysql.so"\nextension = "imagick.so"\nextension = "ftp.so"\n#' $PHP_INI
sed -i 's#output_buffering = Off#output_buffering = On#' $PHP_INI
sed -i "s#; always_populate_raw_post_data = On#always_populate_raw_post_data = On#g" $PHP_INI
sed -i "s#; cgi.fix_pathinfo=0#cgi.fix_pathinfo=0#g" $PHP_INI

cat <<EOF >> $PHP_INI
[eaccelerator]
zend_extension="\${php_ext_dir}/eaccelerator.so"
eaccelerator.shm_size="64"
eaccelerator.cache_dir="\${zend_cache}"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="3600"
eaccelerator.shm_prune_period="3600"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"

[Zend Optimizer]
zend_optimizer.optimization_level=1
zend_optimizer.encoder_loader=0
zend_extension="\${php_ext_dir}/ZendOptimizer.so"
EOF

xsubstitute $ATSS_SETUP_CFG/php.ini $sys_conf/php/php.ini
xsubstitute $ATSS_SETUP_CFG/php.ini $sys_conf/php/php-fpm.conf

xautosave $php_install/etc/php.ini
xautosave $php_install/etc/php-fpm.conf

ln -s $sys_conf/php/php.ini $php_install/etc/
ln -s $sys_conf/php/php-fpm.conf $php_install/etc/

xbin $php_install/bin/php

sed -i s#php_fpm_PID=.*#php_fpm_PID=${php_fpm_pid}# $php_install/sbin/php-fpm
xbin $php_install/sbin/php-fpm

$php_install/bin/php -v

ulimit -SHn 65535
${php_install}/sbin/php-fpm start
#TODO [____ERROR]  {/root/build/ZendOptimizer-3.3.9-linux-glibc23-i386} /webserver/local/php/sbin/php 启动 失败！错误码: 1
#xcheck "${php_install}/sbin/php 启动" $?
