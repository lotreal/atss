#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

link_php_libmhash()
{
    ln -sf /usr/local/lib/libmhash.a /usr/lib/libmhash.a \
        && ln -sf /usr/local/lib/libmhash.la /usr/lib/libmhash.la \
        && ln -sf /usr/local/lib/libmhash.so /usr/lib/libmhash.so \
        && ln -sf /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2 \
        && ln -sf /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
    return $?
}
install_php_libmhash()
{
    xprepare $php_libmhash
    xcheck "./configure"
    xcheck "make"
    xcheck "make install"
    xcheck "link_php_libmhash"
}

install_php_libmhash | tee -a $install_log
