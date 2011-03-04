#!/bin/bash
link_php_libmcrypt()
{
    ln -sf /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la \
        && ln -sf /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so \
        && ln -sf /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4 \
        && ln -sf /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8 \
        && ln -sf /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
    return $?
}

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
