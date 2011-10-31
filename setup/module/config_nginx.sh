#!/bin/bash
source $ATSS_SETUP_CFG/nginx.ini

# 创建 www 和 log 目录
mkdir -p $ATSS_WWW
chmod +w $ATSS_WWW

mkdir -p $ATSS_NGINX_LOG
chmod +w $ATSS_NGINX_LOG
chown -R www-data:www-data $ATSS_NGINX_LOG

xsubstitute $ATSS_SETUP_CFG/nginx.ini $ATSS_NGINX_CFG/nginx.conf
xsubstitute $ATSS_SETUP_CFG/nginx.ini $ATSS_NGINX_CFG/sites-enabled/phpmyadmin
xbin ${ATSS_NGINX_INSTALL}/sbin/nginx

xautosave $ATSS_NGINX_INSTALL/conf/nginx.conf
ln -s $ATSS_RUN_CFG/nginx/nginx.conf $ATSS_NGINX_INSTALL/conf/

#TODO 多域名日志分割
# xuse $bin nginx/nginx_log_cutter.sh
# xbin $ATSS_RUN_CFG/nginx/nginx_log_cutter.sh
# grep nginx_log_cutter.sh /etc/crontab || \
#     echo "00 00 * * * /bin/bash /webserver/bin/nginx_log_cutter.sh" >> /etc/crontab

# xcp $(xgetconf nginx)/_default $www
# chown -R www-data:www-data $www

if ps x | grep -v grep | grep -v install.sh | grep "nginx"; then
    xcheck "${ATSS_NGINX_INSTALL}/sbin/nginx -s reload"
else
    ulimit -SHn 65535
    xcheck "${ATSS_NGINX_INSTALL}/sbin/nginx"
fi
