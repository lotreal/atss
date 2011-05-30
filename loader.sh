#!/bin/bash
xpath() {
    for line in $(tar tf $1); do
        [ "${line//\//}" != $line ] && break
    done
    echo $line | sed "s/^\([^/]*\)\(.*\)$/\1/"
}

###### 1. upgrade system use yum
###### 2. install dependence lib use yum
###### 3. sync date
###### 4. install git

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

/usr/sbin/ntpdate ntp.api.bz

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

# .gitconfig
fi

ssh-keygen -t rsa -C "lotreal@gmail.com"
cat ~/.ssh/id_rsa.pub
echo git clone git@github.com:lotreal/autosrv.git