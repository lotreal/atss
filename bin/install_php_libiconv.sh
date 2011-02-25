#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_php_libiconv()
{
    xprepare $php_libiconv

    ./configure --prefix=/usr/local
    xcheck "conf" $?

    make
    xcheck "make" $?

    make install
    xcheck "make install" $?
}

install_php_libiconv | tee -a $install_log
