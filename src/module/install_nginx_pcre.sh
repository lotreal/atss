#!/bin/bash
# 安装Nginx所需的pcre库：
xprepare $pcre
xcheck "./configure"
xcheck "make"
xcheck "make install"
