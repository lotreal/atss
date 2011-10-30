#!/bin/bash
# 1. Yum upgrade
# 2. Install dependence lib
# 3. Synchronize time via the network
# 4. Install git

# 预测解压位置
xpath() {
    for line in $(tar tf $1); do
        [ "${line//\//}" != $line ] && break
    done
    echo $line | sed "s/^\([^/]*\)\(.*\)$/\1/"
}

## 1. Yum upgrade
yum -y upgrade

## 2. Install dependence lib
yum -y install \
    gcc gcc-c++ autoconf \
    glib2-devel openssl openssl-devel \
    ncurses ncurses-devel \
    curl curl-devel libxml2 libxml2-devel \
    libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
    openldap openldap-devel nss_ldap openldap-clients openldap-servers \
    e2fsprogs e2fsprogs-devel \
    ntp screen

## 3. Synchronize time via the network
/usr/sbin/ntpdate ntp.api.bz

## 4. Install git
which git
if [ $? -ne 0 ]; then
    grep /usr/local/lib /etc/ld.so.conf || echo /usr/local/lib >> /etc/ld.so.conf
    /sbin/ldconfig
    cd /tmp
    [[ -e "git-latest.tar.gz" ]] || wget "http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz"

    package=git-latest.tar.gz
    predict=$(xpath $package)
    tar xzvf $package
    cd $predict
    autoconf
    ./configure --with-curl=/usr/local
    make
    make install
    # TODO .gitconfig
fi

## keygen for github
ssh-keygen -t rsa -C "lotreal@gmail.com"
cat ~/.ssh/id_rsa.pub
echo git clone git@github.com:lotreal/autosrv.git
