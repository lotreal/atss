#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_cookie()
{
    cat <<EOF >> /etc/rc.local
ulimit -SHn 65535
${php_install}/sbin/php-fpm start
${nginx_install}/sbin/nginx
${mysql_server} start
EOF
    xcheck "配置开机自动启动" $?

    cat <<'EOF' >> /etc/sysctl.conf
net.ipv4.tcp_max_syn_backlog = 65536
net.core.netdev_max_backlog = 32768
net.core.somaxconn = 32768

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_tw_recycle = 1
#net.ipv4.tcp_tw_len = 1
net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800

#net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 1024 65535
EOF
    xcheck "优化 Linux 内核参数" $?

    /sbin/sysctl -p
    xcheck "应用 Linux 内核参数" $?

# echo 七、编写每天定时切割Nginx日志的脚本
# echo 1、创建脚本${nginx_install}/sbin/cut_nginx_log.sh
# cat <<EOF > ${nginx_install}/sbin/cut_nginx_log.sh
# #!/bin/bash
# # This script run at 00:00

# # The Nginx logs path
# logs_path="${nginx_install}/logs/"

# mkdir -p \${logs_path}\$(date -d "yesterday" +"%Y")/\$(date -d "yesterday" +"%m")/
# mv \${logs_path}access.log \${logs_path}\$(date -d "yesterday" +"%Y")/\$(date -d "yesterday" +"%m")/access_\$(date -d "yesterday" +"%Y%m%d").log
# kill -USR1 \`cat ${nginx_install}/nginx.pid\`
# EOF

# echo 2、设置crontab，每天凌晨00:00切割nginx访问日志
# echo "00 00 * * * /bin/bash  ${nginx_install}/sbin/cut_nginx_log.sh" >> /etc/crontab
}

install_cookie | tee -a $install_log
