#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_php_libmhash()
{
    xprepare $php_libmhash

    ./configure
    xcheck "conf" $?

    make
    xcheck "make" $?

    make install
    xcheck "make install" $?

    ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
    ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
    ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
    ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1

    xcheck "create link" $?
}

install_php_libmhash | tee -a $install_log
