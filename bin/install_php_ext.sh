#!/bin/bash
if [ "$(basename $0)" != "install_all.sh" ]; then
    source ${0%/*}/config.sh
fi

install_php_ext()
{
    php_install=$srv_bin/php
    mysql_install=$srv_bin/mysql

    # # 安装 pecl_memcache
    # xprepare $pecl_memcache

    # ${php_install}/bin/phpize
    # xcheck "phpize" $?

    # ./configure --with-php-config=${php_install}/bin/php-config
    # xcheck "conf" $?

    # make
    # xcheck "make" $?

    # make install
    # xcheck "make install" $?

    # # 安装 eaccelerator
    # xprepare $eaccelerator

    # ${php_install}/bin/phpize
    # xcheck "phpize" $?

    # ./configure --enable-eaccelerator=shared --with-php-config=${php_install}/bin/php-config
    # xcheck "conf" $?

    # make
    # xcheck "make" $?

    # make install
    # xcheck "make install" $?

    # # 安装 pecl_pdo_mysql
    # xprepare $pecl_pdo_mysql

    # ${php_install}/bin/phpize
    # xcheck "phpize" $?

    # ./configure --with-php-config=${php_install}/bin/php-config --with-pdo-mysql=${mysql_install}
    # xcheck "conf" $?

    # make
    # xcheck "make" $?

    # make install
    # xcheck "make install" $?

    # # 安装 imagemagick
    # xprepare $imagemagick

    # ./configure
    # xcheck "conf" $?

    # make
    # xcheck "make" $?

    # make install
    # xcheck "make install" $?

    # # 安装 pecl_imagick_pkg
    # xprepare $pecl_imagick

    # ${php_install}/bin/phpize
    # xcheck "phpize" $?

    # ./configure --with-php-config=${php_install}/bin/php-config
    # xcheck "conf" $?

    # make
    # xcheck "make" $?

    # make install
    # xcheck "make install" $?

    # 配置 php 和 php-fpm 
    php_ext_dir=$($php_install/bin/php-config --extension-dir 2>/dev/null)
    mkdir -p $zend_cache
    mkdir -p $srv_log/php

    # ${php_install}/etc/php.ini
    # ${php_install}/etc/php-fpm.conf
    php_conf=$srv_etc/php/php.ini
    php_fpm_conf=$srv_etc/php/php-fpm.conf
    mkdir -p $srv_etc/php
    xbackup_if_exist $php_conf
    xbackup_if_exist $php_fpm_conf

    cp $tpl_dir/php/php.ini $php_conf
    cp $tpl_dir/php/php-fpm.conf $php_fpm_conf

    sed -i "s#\${php_ext_dir}#${php_ext_dir}#g" $php_conf
    sed -i "s#\${zend_cache}#${zend_cache}#g" $php_conf

    sed -i "s#\${php_fpm_pid}#${php_fpm_pid}#g" $php_fpm_conf
    sed -i "s#\${php_fpm_err_log}#${php_fpm_err_log}#g" $php_fpm_conf

    ln -sf $php_conf $php_install/etc
    xcheck "创建 $php_install/etc/php.ini" $?

    ln -sf $php_fpm_conf $php_install/etc
    xcheck "创建 $php_install/etc/php-fpm.conf" $?

    /usr/sbin/groupadd www
    xwarning "groupadd www" $?
    /usr/sbin/useradd -g www www
    xwarning "useradd www" $?

    ulimit -SHn 65535
    ${php_install}/sbin/php-fpm start
    xcheck "${php_install}/sbin/php-fpm 启动" $?

}

install_php_ext | tee -a $install_log
