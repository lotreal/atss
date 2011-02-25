#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_mysql()
{
    xprepare $mysql

    mysql_install=$srv_bin/$CURRENT_PACKAGE

    /usr/sbin/groupadd mysql
    xwarning "groupadd mysql" $?

    /usr/sbin/useradd -r -g mysql mysql
    xwarning "useradd mysql" $?

    cmake . \
        -DCMAKE_INSTALL_PREFIX=${mysql_install} \
        -DEXTRA_CHARSETS=all \
        -DWITH_READLINE=1 \
        -DWITH_SSL=yes \
        -DENABLED_LOCAL_INFILE=1 \
        -DWITH_EMBEDDED_SERVER=1 \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DMYSQL_USER=mysql \
        -DMYSQL_TCP_PORT=${mysql_port} \
        -DMYSQL_UNIX_ADDR=${mysql_sock} \
        -DMYSQL_DATADIR=${mysql_data} \
        -DWITH_DEBUG=0
    xcheck "cmake" $?

    make
    xcheck "make" $?

    make install
    xcheck "make install" $?

    [ -L $srv_bin/mysql ] && rm $srv_bin/mysql
    ln -s $mysql_install $srv_bin/mysql
    xcheck "link to mysql" $?
}

install_mysql | tee -a $install_log

# log-error = ${mysql_data}/${mysql_port}/mysql_error.log
# pid-file = ${mysql_data}/${mysql_port}/mysql.pid
# log-bin = ${mysql_data}/${mysql_port}/binlog/binlog
# binlog_cache_size = 4M
# binlog_format = MIXED
# max_binlog_cache_size = 8M
# max_binlog_size = 1G
# relay-log-index = ${mysql_data}/${mysql_port}/relaylog/relaylog
# relay-log-info-file = ${mysql_data}/${mysql_port}/relaylog/relaylog
# relay-log = ${mysql_data}/${mysql_port}/relaylog/relaylog

# # Preconfiguration setup
# shell> groupadd mysql
# shell> useradd -r -g mysql mysql
# # Beginning of source-build specific instructions
# shell> tar zxvf mysql-VERSION.tar.gz
# shell> cd mysql-VERSION
# shell> cmake .
# shell> make
# shell> make install
# # End of source-build specific instructions
# # Postinstallation setup
# shell> cd /usr/local/mysql
# shell> chown -R mysql .
# shell> chgrp -R mysql .
# shell> scripts/mysql_install_db --user=mysql
# shell> chown -R root .
# shell> chown -R mysql data
# # Next command is optional
# shell> cp support-files/my-medium.cnf /etc/my.cnf
# shell> bin/mysqld_safe --user=mysql &
# # Next command is optional
# shell> cp support-files/mysql.server /etc/init.d/mysql.server
