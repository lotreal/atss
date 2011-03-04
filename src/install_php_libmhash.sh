#!/bin/bash
link_php_libmhash()
{
    ln -sf /usr/local/lib/libmhash.a /usr/lib/libmhash.a \
        && ln -sf /usr/local/lib/libmhash.la /usr/lib/libmhash.la \
        && ln -sf /usr/local/lib/libmhash.so /usr/lib/libmhash.so \
        && ln -sf /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2 \
        && ln -sf /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
    return $?
}
xprepare $php_libmhash
xcheck "./configure"
xcheck "make"
xcheck "make install"
xcheck "link_php_libmhash"

xnotify "php_libmhash 安装成功。"
