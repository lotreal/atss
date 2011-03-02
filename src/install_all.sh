#!/bin/bash
if [ "$(basename $0)" != "install.sh" ]; then
    echo "请通过 install.sh all 方式调用。"
    exit 1
fi

xecho "全部安装"
xinstall php_libiconv
xinstall php_libmhash
xinstall php_libmcrypt
xinstall mcrypt

xinstall cmake

# xinstall mysql
# xinstall mysql_data

# xinstall php
# xinstall php_ext

# xinstall nginx

# xinstall cookie
