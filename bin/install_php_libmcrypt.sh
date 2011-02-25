#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_php_libmcrypt()
{
    xprepare $php_libmcrypt

    ./configure
    xcheck "conf" $?

    make
    xcheck "make" $?

    make install
    xcheck "make install" $?

    /sbin/ldconfig
    xcheck "/sbin/ldconfig" $?

    cd libltdl/
    xcheck "进入目录 libltdl" $?

    ./configure --enable-ltdl-install
    xcheck "conf" $?

    make
    xcheck "make" $?

    make install
    xcheck "install" $?

    ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config

    xcheck "create link" $?
}

install_php_libmcrypt | tee -a $install_log
