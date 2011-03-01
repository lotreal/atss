#!/bin/bash
run_date=$(date +%Y-%m-%d-%H%M%S)

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

# 服务器路径配置
srv_bin=/webserver/bin
srv_etc=/webserver/etc
srv_log=/webserver/log
srv_cache=/webserver/cache
srv_data=/data
[ ! -d $srv_bin ] && mkdir -p $srv_bin
[ ! -d $srv_etc ] && mkdir -p $srv_etc
[ ! -d $srv_log ] && mkdir -p $srv_log
[ ! -d $srv_cache ] && mkdir -p $srv_cache
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

php=http://www.php.net/get/php-5.2.14.tar.gz/from/this/mirror
php_fpm=http://php-fpm.org/downloads/php-5.2.14-fpm-0.5.14.diff.gz
eaccelerator=http://bart.eaccelerator.net/source/0.9.6.1/eaccelerator-0.9.6.1.tar.bz2
imagemagick=http://lnmpp.googlecode.com/files/ImageMagick.tar.gz
pecl_memcache=http://pecl.php.net/get/memcache-2.2.5.tgz
pecl_pdo_mysql=http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz
pecl_imagick=http://pecl.php.net/get/imagick-2.3.0.tgz

phpmyadmin_url=http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.3.9/phpMyAdmin-3.3.9-all-languages.tar.gz
pcre=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.10.tar.gz
nginx=http://nginx.org/download/nginx-0.8.54.tar.gz

phpmyadmin_url=http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.3.9/phpMyAdmin-3.3.9-all-languages.tar.gz


# mysql 配置
mysql_install=$srv_bin/mysql
mysql_server=/etc/init.d/mysql.server
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

# php 配置
php_install=$srv_bin/php
zend_cache=$srv_cache/zend
php_fpm_pid=$srv_log/php/php-fpm.pid
php_fpm_err_log=$srv_log/php/php-fpm.log

# nginx 配置
www=$src_data/www
nginx_log=$srv_log/nginx
nginx_install=$srv_bin/nginx
nginx_conf=
fcgi_conf=


# 通用函数
xerror()
{
    echo "【安装错误】[$(pwd)] $@"
}

xok()
{
    echo "【安装成功】[$(pwd)] $@"
}

xalert()
{
    echo "【安装警告】[$(pwd)] $@"
}

xecho()
{
    echo "【安装信息】[$(pwd)] $@"
}

xisint()
{
    if [[ "$1" =~ "^[0-9]+$" ]]; then
        return 0
    else
        return 1
    fi
}

# xwarning()
xcheck()
{
    if [[ $# -eq 0 ]]; then
        cat<<EOF
没有指定参数！xcheck 调用：
xcheck "编译" $?
xcheck "make" => xcall "make" "make"
xcheck "编译" "make"
xcheck "编译" "make" w
xcheck "编译" "make" w
EOF
        return 1
    fi

    local desc=$1
    declare -i exit_code
    declare -i halt_flag

    if [[ $# -eq 1 ]]; then
        fn=$desc
    else
        fn=$2
    fi
    # 默认出错时退出；但指定了第三个参数时，出错只警告
    if [[ $# -eq 3 ]]; then
        halt_flag=1
    else
        halt_flag=0
    fi

    if xisint $fn; then
        exit_code=$fn
    else
        $fn
        exit_code=$?
    fi

    if [ "$exit_code" -ne 0 ]; then
        if [[ halt_flag -eq 0 ]]; then
            xerror "$desc 失败！错误码: $ec"
            exit $?
        else
            xalert "$desc 失败！错误码: $ec"
            return $?
        fi
    else
        xok "$desc 成功。"
        return 0
    fi
}

# xconf()
# {
#     xcheck "./configure $@"
# }

# xmake()
# {
#     xcheck "make"
# }

# xinstall()
# {
#     xcheck "make install"
# }

xbackup_if_exist()
{
    if [ -e $1 ]; then
        xcheck "$1 已存在，备份老文件到 $1.$run_date" "mv $1 $1.$run_date"
    fi
}

# 为简化正则表达式，要求 xpackage 的参数必须是完整的路径
xpackage()
{
    echo $1 | sed "s/^\(.*\)\/\([^/?]*\)\.\(gz\|tgz\|bz2\)\(.*\)$/\2\.\3/"
}

# 预测解压路径
xpath()
{
    for line in $(tar tf $1); do
        [ "${line//\//}" != $line ] && break
    done
    echo $line | sed "s/^\([^/]*\)\(.*\)$/\1/"
}

xprepare()
{
    local uri=$1
    local package=$cache_dir/$(xpackage $uri)
    xecho "准备安装 $package"

    if [ ! -e $package ]; then
        xerror "找不到 $package"
        exit
    fi


    local predict=$(xpath $package)
    if [ "$predict" == "" ]; then
        xerror "不能预测 $package 的解压位置"
        exit
    fi

    xecho "预计解压到 $build_dir/$predict"
    CURRENT_PACKAGE=$predict

    cd $build_dir

    if [ -d $predict ]; then
        xecho "文件夹 $predict 已存在，正在删除……"
        rm $predict -rf
    fi

    xecho "正在解压 $package"
    xecho "到 $build_dir ……"
    tar xf $package -C ${build_dir}

    xcheck "cd $predict"
}

# boot
xbackup_if_exist $install_log
xecho "读取配置文件成功" | tee -a $install_log
