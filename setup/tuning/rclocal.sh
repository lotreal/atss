#!/bin/bash
cat <<EOF >> /etc/rc.local
ulimit -SHn 65535
${mysql_server} start
${php_install}/sbin/php-fpm start
${nginx_install}/sbin/nginx
EOF
xcheck "配置开机自动启动" $?