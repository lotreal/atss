#!/bin/bash
source h.sh

# echo "0 3 1 * * /sbin/reboot" >> /var/spool/cron/root
# echo "0 * * * * ntpdate us.pool.ntp.org" >> /var/spool/cron/root

xlog notice "【安装暂停】现在将进行 mysql 设置，请输入密码继续……"
echo "设置 root 密码："
echo "随机密码：$(xmkpasswd) $(xmkpasswd) $(xmkpasswd) $(xmkpasswd) $(xmkpasswd)"
cd $mysql_install && bin/mysql_secure_installation
xcheck "mysql_secure_installation" $?
