#!/bin/bash
if [ ! -d $mysql_data/mysql ]; then
    mkdir -p ${mysql_data}
    chown -R mysql:mysql ${mysql_data}

    mkdir -p ${mysql_bin_log}
    mkdir -p ${mysql_relay_log}
    mkdir -p ${mysql_slow_log}
    chown -R mysql:mysql ${mysql_log}
    xcheck "chmod & chown ${mysql_data} & ${mysql_log}" $?

    ${mysql_install}/scripts/mysql_install_db \
        --basedir=${mysql_install} \
        --datadir=${mysql_data} \
        --user=mysql
    xcheck "以 mysql 用户身份建立数据表" $?

    mysql_conf=$mysql_data/my.cnf
    xconf mysql $mysql_conf
    xcheck "创建 $mysql_data/my.cnf" $?

    sed -i "s#\${mysql_port}#${mysql_port}#g" $mysql_conf
    sed -i "s#\${mysql_sock}#${mysql_sock}#g" $mysql_conf
    sed -i "s#\${mysql_install}#${mysql_install}#g" $mysql_conf
    sed -i "s#\${mysql_pid}#${mysql_pid}#g" $mysql_conf
    sed -i "s#\${mysql_data}#${mysql_data}#g" $mysql_conf
    sed -i "s#\${mysql_error_log}#${mysql_error_log}#g" $mysql_conf
    sed -i "s#\${mysql_bin_log}#${mysql_bin_log}#g" $mysql_conf
    sed -i "s#\${mysql_relay_log}#${mysql_relay_log}#g" $mysql_conf
    sed -i "s#\${mysql_slow_log}#${mysql_slow_log}#g" $mysql_conf

    cp ${mysql_install}/support-files/mysql.server $mysql_server
    xcheck "创建启动脚本 $mysql_server" $?

    $mysql_server start
    xcheck "启动 $mysql_server" $?

    xnotify "【安装暂停】现在将进行 mysql 设置，请输入密码继续……"
    echo "设置 root 密码："
    echo "随机密码：$(xmkpasswd) $(xmkpasswd) $(xmkpasswd) $(xmkpasswd) $(xmkpasswd)"
    cd $mysql_install && bin/mysql_secure_installation
    xcheck "mysql_secure_installation" $?
else
    echo "【安装警示】目录 $mysql_data/mysql 已存在，跳过初始化数据表，以避免丢失数据！"
fi

$swd/tools/bitlbee_send.py "完成运行 install_mysql_data.sh。"
xnotify "mysql 配置成功。"