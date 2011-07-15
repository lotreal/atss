#!/bin/bash
source $meta/mysql.ini

xprepare $mysql

mysql_verion_install=$sys_install/$CURRENT_PACKAGE
echo $mysql_verion_install

/usr/sbin/groupadd mysql
xcheck "groupadd mysql" $? w

/usr/sbin/useradd -r -g mysql mysql
xcheck "useradd mysql" $? w

cmake . \
    -DCMAKE_INSTALL_PREFIX=${mysql_verion_install} \
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

xcheck "make"
xcheck "make install"

# # 创建 mysql 链接
xautosave $mysql_install
xcheck "ln -s $mysql_verion_install $mysql_install"

xcheck "ln -sf $mysql_install/lib/libmysqlclient.so* /usr/lib/"
/sbin/ldconfig
