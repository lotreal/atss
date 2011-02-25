#!/bin/bash
run_date=`date +%Y-%m-%d-%H%M%S`

wd=$(dirname $(readlink -f $0))
swd=$(cd $wd/../ && pwd)

bin_dir=$swd/bin
cache_dir=$swd/archives
tpl_dir=$swd/templates

log_dir=$swd/log
build_dir=$swd/build
[ ! -d $build_dir ] && mkdir -p $build_dir
[ ! -d $log_dir ] && mkdir -p $log_dir

# 安装日志
install_log=$log_dir/install.log

if [ -e $install_log ]; then
    mv $install_log $log_dir/install.$run_date.backup.log
fi

# 服务器路径配置
srv_bin=/webserver/bin
srv_etc=/webserver/etc
srv_log=/webserver/log
srv_data=/data
[ ! -d $srv_bin ] && mkdir -p $srv_bin
[ ! -d $srv_etc ] && mkdir -p $srv_etc
[ ! -d $srv_log ] && mkdir -p $srv_log
[ ! -d $srv_data ] && mkdir -p $srv_data

# 全局变量，用于函数返回
CURRENT_PACKAGE=

# 安装包地址
php_libiconv=http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
php_libmhash="http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz?modtime=1175740843&big_mirror=0"
php_libmcrypt="http://downloads.sourceforge.net/mcrypt/libmcrypt-2.5.8.tar.gz?modtime=1171868460&big_mirror=0"
mcrypt="http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz?modtime=1194463373&big_mirror=0"

cmake=http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz
# mysql=http://downloads.mysql.com/archives/mysql-5.5/mysql-5.5.5-m3.tar.gz
# mysql=http://downloads.mysql.com/archives/mysql-5.5/mysql-5.5.8.tar.gz
mysql=http://mirror.services.wisc.edu/mysql/Downloads/MySQL-5.5/mysql-5.5.9.tar.gz

# mysql 配置
mysql_conf=$srv_etc/mysql/
mysql_port=3306
mysql_sock=/tmp/mysqld.sock

mysql_data=$srv_data/mysql/${mysql_port}/data
mysql_pid=$mysql_data/mysql.pid

mysql_log=$srv_log/mysql/${mysql_port}
mysql_error_log=${mysql_log}/mysql_error.log
mysql_bin_log=${mysql_log}/binlog
mysql_relay_log=${mysql_log}/relaylog
mysql_slow_log=${mysql_log}/slowlog

# mysql_username="admin"
# mysql_password="mVctQWXCYafn8qYQ"
# #phpmyadmin: http://www.cqq.com:27654
# #mysql: root:taGuneexq24KnAqm
# #ftp: ftpcqq:xMfRStKGVV82nsxS
# ftp_user=ftpcqq
# ftp_passwd=xMfRStKGVV82nsxS


# php_install=/usr/local/webserver/php
# zend_install=/usr/local/webserver/eaccelerator_cache
# nginx_install=/usr/local/webserver/nginx
# main_domain="www.cqq.com *.cqq.com"




nginx_url=http://nginx.org/download/nginx-0.8.54.tar.gz

php_url=http://www.php.net/get/php-5.2.14.tar.gz/from/this/mirror
php_fpm_url=http://php-fpm.org/downloads/php-5.2.14-fpm-0.5.14.diff.gz
libiconv_url=http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
libmcrypt_url="http://downloads.sourceforge.net/mcrypt/libmcrypt-2.5.8.tar.gz?modtime=1171868460&big_mirror=0"
mcrypt_url="http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz?modtime=1194463373&big_mirror=0"
mhash_url="http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz?modtime=1175740843&big_mirror=0"
pcre_url=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.10.tar.gz
eaccelerator_url=http://bart.eaccelerator.net/source/0.9.6.1/eaccelerator-0.9.6.1.tar.bz2
imagemagick_url=http://lnmpp.googlecode.com/files/ImageMagick.tar.gz
pecl_memcache_url=http://pecl.php.net/get/memcache-2.2.5.tgz
pecl_pdo_mysql_url=http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz
pecl_imagick_url=http://pecl.php.net/get/imagick-2.3.0.tgz
phpmyadmin_url=http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.3.9/phpMyAdmin-3.3.9-all-languages.tar.gz


# 通用函数
xlog()
{
    local t=1
}

xecho()
{
    echo "xecho $@"
}

xpackage()
{
    echo $1 | sed "s/^\(.*\)\/\([^/?]*\)\.\(tar\.gz\|tgz\|bz2\)\(.*\)$/\2\.\3/"
}

xpath()
{
    tar tf $1 | head -1 | sed "s/^\([^/]*\)\(.*\)$/\1/"
}

xprepare()
{
    local uri=$1
    local package=$cache_dir/`xpackage $uri`
    echo "【安装信息】准备安装 $package"

    local predict=`xpath $package`
    if [ "$predict" == "" ]; then
        echo "【安装错误】找不到 $package ！"
        exit
    else
        echo "【安装信息】将解压到 $build_dir/$predict 。"
        CURRENT_PACKAGE=$predict
    fi

    cd $build_dir

    if [ -d $predict ]; then
        echo "【安装信息】文件夹 $predict 已存在，正在删除……"
        rm $predict -rf
    fi

    echo "【安装信息】正在解压……"
    echo "【安装信息】$package"
    echo "【安装信息】到"
    echo "【安装信息】$build_dir"
    tar xf $package -C ${build_dir}

    cd $predict
    echo "【安装信息】进入目录 $(pwd)"
}

xwarning()
{
    if [ "$2" -ne 0 ];then
	echo "【安装警示】[$(pwd)]# $1 失败！ErrorCode:$2"
    else
        echo "【安装信息】[$(pwd)]# $1 成功！"
    fi
}

xcheck()
{
    if [ "$2" -ne 0 ];then
	echo "【安装错误】[$(pwd)]# $1 失败！ErrorCode:$2"
	exit $2
    else
        echo "【安装信息】[$(pwd)]# $1 成功！"
    fi
}

xcheckconf()
{
    xcheck "conf" $1
}

xcheckmake()
{
    xcheck "make" $1
}

xcheckinstall()
{
    xcheck "make install" $1
}
echo "【安装信息】[$(pwd)]# 读取配置文件成功！" | tee -a $install_log
