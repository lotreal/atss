#!/bin/bash
source $ATSS_SETUP_CFG/nginx.ini

# 创建 www 和 log 目录
mkdir -p $_WWW
chmod +w $_WWW

mkdir -p $_NGINX_LOG
chmod +w $_NGINX_LOG
chown -R www-data:www-data $_NGINX_LOG

xsubstitute $ATSS_SETUP_CFG/nginx.ini $_NGINX_ETC/nginx.conf
xsubstitute $ATSS_SETUP_CFG/nginx.ini $_NGINX_ETC/sites-enabled/phpmyadmin
xbin ${_NGINX_INSTALL}/sbin/nginx

xautosave $_NGINX_INSTALL/conf/nginx.conf
ln -s $_ETC/nginx/nginx.conf $_NGINX_INSTALL/conf/

#TODO 多域名日志分割
# xuse $bin nginx/nginx_log_cutter.sh
# xbin $sys_conf/nginx/nginx_log_cutter.sh
# grep nginx_log_cutter.sh /etc/crontab || \
#     echo "00 00 * * * /bin/bash /webserver/bin/nginx_log_cutter.sh" >> /etc/crontab

# xcp $(xgetconf nginx)/_default $www
# chown -R www-data:www-data $www

if ps x | grep -v grep | grep -v install.sh | grep "nginx"; then
    xcheck "${_NGINX_INSTALL}/sbin/nginx -s reload"
else
    ulimit -SHn 65535
    xcheck "${_NGINX_INSTALL}/sbin/nginx"
fi
