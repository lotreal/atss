#!/bin/bash
source $ATSS_SETUP_CFG/nginx.ini

xprepare $nginx
ATSS_NGINX_INSTALL_PREFIX=$ATSS_RUN_LOCAL/$CURRENT_PACKAGE
cat $ATSS_SETUP_PKG/nginx-0.8.54-custom-ver.diff | patch -d . -p1

if [ ! -d $ATSS_NGINX_INSTALL_PREFIX ]; then
    xcheck "./configure --user=www-data --group=www-data --prefix=${ATSS_NGINX_INSTALL_PREFIX} --with-http_stub_status_module --with-http_ssl_module"
    xcheck "make"
    xcheck "make install"
    xautosave $ATSS_NGINX_INSTALL
    ln -s $ATSS_NGINX_INSTALL_PREFIX $ATSS_NGINX_INSTALL
else
    xlog alert "【安装警示】 $ATSS_NGINX_INSTALL_PREFIX 已存在，跳过安装 nginx"
fi

