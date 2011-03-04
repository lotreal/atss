#!/bin/bash
# 配置 php 和 php-fpm 
php_ext_dir=$($php_install/bin/php-config --extension-dir 2>/dev/null)

# 复制 ZendOptimizer.so
xprepare $zend_optimizer
xcheck "cp data/5_2_x_comp/ZendOptimizer.so $php_ext_dir"
chcon -t httpd_sys_content_t $php_ext_dir/ZendOptimizer.so
chcon -t textrel_shlib_t $php_ext_dir/ZendOptimizer.so

mkdir -p $zend_cache
chmod -R +w $zend_cache
chown -R www:www $zend_cache

mkdir -p $php_log

php_conf=$php_install/etc/php.ini
xconf php $php_conf
xcheck "创建 $php_install/etc/php.ini" $?

php_fpm_conf=$php_install/etc/php-fpm.conf
xconf php $php_fpm_conf
xcheck "创建 $php_install/etc/php-fpm.conf" $?

sed -i "s#\${php_ext_dir}#${php_ext_dir}#g" $php_conf
sed -i "s#\${zend_cache}#${zend_cache}#g" $php_conf

sed -i "s#\${php_fpm_pid}#${php_fpm_pid}#g" $php_fpm_conf
sed -i "s#\${php_fpm_err_log}#${php_fpm_err_log}#g" $php_fpm_conf


/usr/sbin/groupadd www
xcheck "groupadd www" $? w
/usr/sbin/useradd -g www www
xcheck "useradd www" $? w

xbin $php_install/sbin/php-fpm

ulimit -SHn 65535
${php_install}/sbin/php-fpm start
xcheck "${php_install}/sbin/php-fpm 启动" $?
