#!/bin/bash
xprepare $mcrypt
xcheck "/sbin/ldconfig"
xcheck "./configure"
xcheck "make"
xcheck "make install"

xnotify "mcrypt 安装成功。"
