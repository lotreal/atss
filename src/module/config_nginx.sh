#!/bin/bash
# 创建 www 和 log 目录
mkdir -p $www
chmod +w $www

mkdir -p $nginx_log
chmod +w $nginx_log
chown -R www-data:www-data $nginx_log

xcp $(xgetconf nginx)/conf $sys_conf/nginx "www nginx_install nginx_conf nginx_log"
xautosave $nginx_install/conf/nginx.conf
ln -s $sys_conf/nginx/nginx.conf $nginx_install/conf/
xbin ${nginx_install}/sbin/nginx

#TODO 多域名日志分割
# xbin $sys_conf/nginx/nginx_log_cutter.sh
# grep nginx_log_cutter.sh /etc/crontab || \
#     echo "00 00 * * * /bin/bash /webserver/bin/nginx_log_cutter.sh" >> /etc/crontab

xcp $(xgetconf nginx)/_default $www
chown -R www-data:www-data $www

if ps x | grep -v grep | grep -v install.sh | grep "nginx"; then
    xcheck "${nginx_install}/sbin/nginx -s reload"
else
    ulimit -SHn 65535
    xcheck "${nginx_install}/sbin/nginx"
fi