#!/bin/bash
xprepare $php_libiconv
xcheck "./configure --prefix=/usr/local"
xcheck "make"
xcheck "make install"

xnotify "php_libiconv 安装成功。"
