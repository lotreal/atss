ln -s mysql/my.cnf

cp ${mysql_install}/support-files/mysql.server $default_profile/mysql/
xconf /etc/init.d/ mysql/mysql.server
xbin $mysql_server
xcheck "创建启动脚本 $mysql_server" $?

# ==============================================================================
# gen php.ini.tpl
sed -i 's#extension_dir = "./"#extension_dir = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20060613/"\nextension = "memcache.so"\nextension = "pdo_mysql.so"\nextension = "imagick.so"\n#' /usr/local/webserver/php/etc/php.ini
sed -i 's#output_buffering = Off#output_buffering = On#' /usr/local/webserver/php/etc/php.ini
sed -i "s#; always_populate_raw_post_data = On#always_populate_raw_post_data = On#g" /usr/local/webserver/php/etc/php.ini
sed -i "s#; cgi.fix_pathinfo=0#cgi.fix_pathinfo=0#g" /usr/local/webserver/php/etc/php.ini

[eaccelerator]
zend_extension="/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20060613/eaccelerator.so"
eaccelerator.shm_size="64"
eaccelerator.cache_dir="/usr/local/webserver/eaccelerator_cache"
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

php_conf=$php_install/etc/php.ini
xconf $php_install/etc php/php.ini "php_ext_dir zend_cache"
xcheck "创建 $php_install/etc/php.ini" $?

php_fpm_conf=$php_install/etc/php-fpm.conf
php_fpm_pid=$php_install/logs/php-fpm.pid
xconf $php_install/etc php/php-fpm.conf "php_fpm_pid php_fpm_err_log"
xcheck "创建 $php_install/etc/php-fpm.conf" $?
