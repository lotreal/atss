#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_mcrypt()
{
    xprepare $mcrypt

    /sbin/ldconfig
    xcheck "/sbin/ldconfig" $?

    ./configure
    xcheck "conf" $?

    make
    xcheck "make" $?

    make install
    xcheck "make install" $?
}

install_mcrypt | tee -a $install_log
