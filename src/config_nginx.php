#!/bin/bash
# 创建 www 和 log 目录
mkdir -p $www
chmod +w $www
chown -R www:www $www

mkdir -p $nginx_log
chmod +w $nginx_log
chown -R www:www $nginx_log

nginx_conf=$nginx_install/conf/nginx.conf
xconf nginx $nginx_conf

sed -i "s#\${nginx_log}#${nginx_log}#g" $nginx_conf
sed -i "s#\${nginx_install}#${nginx_install}#g" $nginx_conf

xconf nginx $nginx_install/conf/fcgi.conf

ulimit -SHn 65535
xcheck "${nginx_install}/sbin/nginx 启动" "${nginx_install}/sbin/nginx"
