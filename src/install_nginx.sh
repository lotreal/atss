#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_nginx()
{
    # 安装Nginx所需的pcre库：
    # xprepare $pcre
    # xconf
    # xmake
    # xinstall
    xprepare $nginx
    nginx_version_install=$srv_bin/$CURRENT_PACKAGE

    if [ ! -d $nginx_version_install ]; then
        xcheck "./configure --user=www --group=www --prefix=${nginx_version_install} --with-http_stub_status_module --with-http_ssl_module"

        xcheck "make"
        xcheck "make install"
    else
        echo "【安装警示】 $nginx_version_install 已存在，跳过安装 nginx"
    fi

    xbackup_if_exist $srv_bin/nginx
    ln -s $nginx_version_install $srv_bin/nginx

    # 创建 www 和 log 目录
    mkdir -p $www
    chmod +w $www
    chown -R www:www $www

    mkdir -p $nginx_log
    chmod +w $nginx_log
    chown -R www:www $nginx_log

    nginx_conf=$(xconf nginx nginx.conf $nginx_install/conf)
    fcgi_conf=$(xconf nginx fcgi.conf $nginx_install/conf)

    sed -i "s#\${nginx_log}#${nginx_log}#g" $nginx_conf
    sed -i "s#\${nginx_install}#${nginx_install}#g" $nginx_conf

    ulimit -SHn 65535
    xcheck "${nginx_install}/sbin/nginx" "${nginx_install}/sbin/nginx 启动"
}

install_nginx | tee -a $install_log
