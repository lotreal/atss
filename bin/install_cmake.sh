#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_cmake()
{
    xprepare $cmake

    ./bootstrap
    xcheck "bootstrap" $?

    make
    xcheck "make" $?

    make install
    xcheck "make install" $?
}

install_cmake | tee -a $install_log
