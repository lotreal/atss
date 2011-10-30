#!/bin/bash
source $ATSS_SETUP_CFG/php.ini
# 复制 ZendOptimizer.so
# TODO fix x64 zend
xprepare $zend_optimizer
xcheck "cp data/5_2_x_comp/ZendOptimizer.so $php_ext_dir"
chcon -t httpd_sys_content_t $php_ext_dir/ZendOptimizer.so
chcon -t textrel_shlib_t $php_ext_dir/ZendOptimizer.so

mkdir -p $zend_cache
chmod -R +w $zend_cache
chown -R www-data:www-data $zend_cache
