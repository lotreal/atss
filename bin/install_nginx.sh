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
    nginx_install=$srv_bin/$CURRENT_PACKAGE
    nginx_conf=$nginx_install/conf/nginx.conf
    fcgi_conf=$nginx_install/conf/fcgi.conf

    if [ ! -d $nginx_install ]; then
        xcheck "./configure --user=www --group=www --prefix=${nginx_install} --with-http_stub_status_module --with-http_ssl_module"

        xcheck "make"
        xcheck "make install"
    else
        echo "【安装警示】 $nginx_install 已存在，跳过安装 nginx"
    fi

    xbackup_if_exist $srv_bin/nginx
    ln -s $nginx_install $srv_bin/nginx

    # 创建 www 和 log 目录
    mkdir -p $www
    chmod +w $www
    chown -R www:www $www

    mkdir -p $nginx_log
    chmod +w $nginx_log
    chown -R www:www $nginx_log

    mkdir -p $srv_etc/nginx
    cp $tpl_dir/nginx/nginx.conf $srv_etc/nginx
    cp $tpl_dir/nginx/fcgi.conf $srv_etc/nginx

    xbackup_if_exist $nginx_conf
    xbackup_if_exist $fcgi_conf
    ln -s $srv_etc/nginx/nginx.conf $nginx_conf
    ln -s $srv_etc/nginx/fcgi.conf $fcgi_conf

    sed -i "s#\${nginx_log}#${nginx_log}#g" $nginx_conf
    sed -i "s#\${nginx_install}#${nginx_install}#g" $nginx_conf

    ulimit -SHn 65535
    xcheck "${nginx_install}/sbin/nginx" "${nginx_install}/sbin/nginx 启动"
}

install_nginx | tee -a $install_log
