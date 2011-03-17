#!/bin/bash
# 安装Nginx所需的pcre库：
xprepare $pcre
xcheck "./configure"
xcheck "make"
xcheck "make install"


xprepare $nginx
nginx_version_install=$sys_install/$CURRENT_PACKAGE

if [ ! -d $nginx_version_install ]; then
    xcheck "./configure --user=www-data --group=www-data --prefix=${nginx_version_install} --with-http_stub_status_module --with-http_ssl_module"
    xcheck "make"
    xcheck "make install"
else
    xlog alert "【安装警示】 $nginx_version_install 已存在，跳过安装 nginx"
fi

xautosave $nginx_install
ln -s $nginx_version_install $nginx_install
