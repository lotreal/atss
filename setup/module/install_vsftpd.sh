#!/bin/bash
xcheck "yum -y install vsftpd db4 db4-tcl db4-utils"

vsftpd_banner=Welcome to HongJu FTP servers
vsftpd_conf=$sys_conf/vsftpd
vsftpd_log=$sys_log/vsftpd

mkdir -p $vsftpd_log
# chmod +w $vsftpd_log
# chown -R www-data:www-data $vsftpd_log

xcp $(xgetconf vsftpd) $sys_conf "www vsftpd_banner vsftpd_conf vsftpd_log"

xautosave /etc/vsftpd/vsftpd.conf
mv $vsftpd_conf/vsftpd.conf /etc/vsftpd/
ln -s /etc/vsftpd/vsftpd.conf $vsftpd_conf/

xautosave /etc/pam.d/vsftpd
ln -s $vsftpd_conf/vsftpd /etc/pam.d/

#TODO 自动生成用户配置文件
xbin $vsftpd_conf/vsftpd_update_passwd.sh
$vsftpd_conf/vsftpd_update_passwd.sh

# TODO fix vsftpd start cant find /etv/vsftpd/vsftpd.conf
# service vsftpd restart

# 参考 http://www.hao32.com/webserver/279.html
# ftp服务器连接失败,错误提示:
# 500 OOPS: cannot change directory:/home/*******
# 500 OOPS: child died

# 解决方法:
# 在终端输入命令：
# setsebool ftpd_disable_trans 1
# service vsftpd restart