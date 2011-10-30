#!/bin/bash
source $ATSS_SETUP_CFG/mysql.ini

mkdir -p ${mysql_data}
chown -R mysql:mysql ${mysql_data}

mkdir -p ${mysql_bin_log}
mkdir -p ${mysql_relay_log}
mkdir -p ${mysql_slow_log}
chown -R mysql:mysql ${mysql_log}

xcheck "chmod & chown ${mysql_data} & ${mysql_log}" $?


xsubstitute $ATSS_SETUP_CFG/mysql.ini $sys_conf/mysql/my.cnf
ln -s $sys_conf/mysql/my.cnf $mysql_data/

DATA_EXIST=
if [[ ! -d $mysql_data/mysql ]]; then
    DATA_EXIST=0
fi

if [[ $DATA_EXIST == 0 ]]; then
    ${mysql_install}/scripts/mysql_install_db \
        --basedir=${mysql_install} \
        --datadir=${mysql_data} \
        --user=mysql
    xcheck "以 mysql 用户身份建立数据表" $?
else
    echo "【安装警示】目录 $mysql_data/mysql 已存在，跳过初始化数据表，以避免丢失数据！"
fi


# todo mysql.server 
# cp ${mysql_install}/support-files/mysql.server sets/dynamic/
xautosave $mysql_server
cp ${mysql_install}/support-files/mysql.server $mysql_server

$mysql_server start --socket=$mysql_sock
xcheck "启动 $mysql_server" $?

if [[ $DATA_EXIST == 0 ]]; then
    xlog notice "【安装暂停】现在将进行 mysql 设置，请输入密码继续……"
    echo "设置 root 密码："
    mysql_passwd=$(openssl rand -base64 18)
    echo mysql_user=root >> $report
    echo mysql_passwd=$mysql_passwd >> $report
    echo "随机密码：$mysql_passwd "
    cd $mysql_install && bin/mysql_secure_installation
    xcheck "mysql_secure_installation" $?
else
    echo "【安装警示】目录 $mysql_data/mysql 已存在，跳过初始化数据表，以避免丢失数据！"
fi

# $mysql_server stop
# rm $mysql_data -rf
