#!/bin/bash
wd=$(dirname $(readlink -f $0))
swd=$(cd $wd/../ && pwd)

detc=$swd/rc
dlog=$swd/log
dbin=$swd/pkgs
dbuild=$swd/build

getfname() {
    echo $1 | sed "s/^\(.*\)\/\([^/?]*\)\.\(tar\.gz\|tgz\|bz2\)\(.*\)$/\2\.\3/"
}
getzname() {
    tar ztf $1 | head -1
}


nginx_url=http://nginx.org/download/nginx-0.8.54.tar.gz
mysql_url=http://downloads.mysql.com/archives/mysql-5.5/mysql-5.5.5-m3.tar.gz
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






# mysql_install=/usr/local/webserver/mysql
# mysql_data=/data0/mysql
# mysql_port=3306
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
