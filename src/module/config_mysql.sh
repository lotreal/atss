#!/bin/bash
mkdir -p ${mysql_data}
chown -R mysql:mysql ${mysql_data}

mkdir -p ${mysql_bin_log}
mkdir -p ${mysql_relay_log}
mkdir -p ${mysql_slow_log}
chown -R mysql:mysql ${mysql_log}
xcheck "chmod & chown ${mysql_data} & ${mysql_log}" $?


if [ ! -d $mysql_data ]; then
    ${mysql_install}/scripts/mysql_install_db \
        --basedir=${mysql_install} \
        --datadir=${mysql_data} \
        --user=mysql
    xcheck "以 mysql 用户身份建立数据表" $?
else
    echo "【安装警示】目录 $mysql_data/mysql 已存在，跳过初始化数据表，以避免丢失数据！"
fi


mysql_conf=$mysql_data/my.cnf

xconf $mysql_data mysql/my.cnf "mysql_port mysql_sock mysql_install mysql_pid mysql_data mysql_error_log mysql_bin_log mysql_relay_log mysql_slow_log"
xcheck "创建 $mysql_data/my.cnf" $?

# todo mysql.server 
cp ${mysql_install}/support-files/mysql.server $default_profile/mysql/
xconf /etc/init.d/ mysql/mysql.server
xbin $mysql_server
xcheck "创建启动脚本 $mysql_server" $?

$mysql_server start
xcheck "启动 $mysql_server" $?

# xlog notice "【安装暂停】现在将进行 mysql 设置，请输入密码继续……"
# echo "设置 root 密码："
# echo "随机密码：$(xmkpasswd) $(xmkpasswd) $(xmkpasswd) $(xmkpasswd) $(xmkpasswd)"
# cd $mysql_install && bin/mysql_secure_installation
# xcheck "mysql_secure_installation" $?
