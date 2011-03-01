#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

link_php_libmcrypt()
{
    ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
}

install_php_libmcrypt()
{
    xprepare $php_libmcrypt
    xcheck "./configure"
    xcheck "make"
    xcheck "make install"
    xcheck "/sbin/ldconfig"
    xcheck "cd libltdl/"
    xcheck "./configure --enable-ltdl-install"
    xcheck "make"
    xcheck "make install"
    xcheck "link_php_libmcrypt"
}

install_php_libmcrypt | tee -a $install_log
