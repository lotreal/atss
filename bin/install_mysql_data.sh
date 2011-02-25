#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_mysql_data()
{
    # chmod +w ${mysql_install}
    # chown -R mysql:mysql ${mysql_install}
    # chown -R root ${mysql_install}
    # xcheck "chmod & chown ${mysql_install}" $?
    mkdir -p ${mysql_data}
    chown -R mysql:mysql ${mysql_data}

    mkdir -p ${mysql_bin_log}
    mkdir -p ${mysql_relay_log}
    mkdir -p ${mysql_slow_log}
    chown -R mysql:mysql ${mysql_log}

    xcheck "chmod & chown ${mysql_data} & ${mysql_log}" $?

    if [ ! -d $mysql_data/mysql ]; then
        ${mysql_install}/scripts/mysql_install_db \
            --basedir=${mysql_install} \
            --datadir=${mysql_data} \
            --user=mysql
        xcheck "以 mysql 用户身份建立数据表" $?
    else
        echo "【安装警示】目录 $mysql_data/mysql 已存在，跳过初始化数据表，以避免丢失数据！"
    fi

    echo 创建my.cnf配置文件
    cp -r $tpl_dir/mysql $etc_dir

    sed -i "s#\${mysql_port}#${mysql_port}#g" $mysql_conf
    sed -i "s#\${mysql_sock}#${mysql_sock}#g" $mysql_conf
    sed -i "s#\${mysql_install}#${mysql_install}#g" $mysql_conf
    sed -i "s#\${mysql_pid}#${mysql_pid}#g" $mysql_conf
    sed -i "s#\${mysql_data}#${mysql_data}#g" $mysql_conf
    sed -i "s#\${mysql_error_log}#${mysql_error_log}#g" $mysql_conf
    sed -i "s#\${mysql_bin_log}#${mysql_bin_log}#g" $mysql_conf
    sed -i "s#\${mysql_relay_log}#${mysql_relay_log}#g" $mysql_conf
    sed -i "s#\${mysql_slow_log}#${mysql_slow_log}#g" $mysql_conf

    echo 创建管理MySQL数据库的shell脚本
    cp ${mysql_install}/support-files/mysql.server /etc/init.d/mysql.server
}

install_mysql_data | tee -a $install_log
