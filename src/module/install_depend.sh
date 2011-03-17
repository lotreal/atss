#!/bin/bash
yum -y upgrade

yum -y install \
    gcc gcc-c++ autoconf \
    glib2-devel openssl openssl-devel \
    ncurses ncurses-devel \
    curl curl-devel libxml2 libxml2-devel \
    libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
    openldap openldap-devel nss_ldap openldap-clients openldap-servers \
    e2fsprogs e2fsprogs-devel \
    ntp screen

ntpdate us.pool.ntp.org
