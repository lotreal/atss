#!/bin/bash
source $ATSS_SETUP_CFG/nginx.ini

xprepare $nginx
_NGINX_INSTALL_PREFIX=$_SBIN/$CURRENT_PACKAGE
cat $ATSS_SETUP_PKG/nginx-0.8.54-custom-ver.diff | patch -d . -p1

if [ ! -d $_NGINX_INSTALL_PREFIX ]; then
    xcheck "./configure --user=www-data --group=www-data --prefix=${_NGINX_INSTALL_PREFIX} --with-http_stub_status_module --with-http_ssl_module"
    xcheck "make"
    xcheck "make install"
    xautosave $_NGINX_INSTALL
    ln -s $_NGINX_INSTALL_PREFIX $_NGINX_INSTALL
else
    xlog alert "【安装警示】 $_NGINX_INSTALL_PREFIX 已存在，跳过安装 nginx"
fi

