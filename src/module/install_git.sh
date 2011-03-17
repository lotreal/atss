#!/bin/bash
# xprepare $bitlbee
# xcheck "./configure --ssl=openssl"
# xcheck "make"
# xcheck "make install"
# xcheck "make install-etc"

# yum -y install zlib-devel openssl-devel perl cpio expat-devel gettext-devel
# xprepare "http://curl.haxx.se/download/curl-7.21.4.tar.bz2"
# xcheck "./configure"
# xcheck "make"
# xcheck "make install"

grep /usr/local/lib /etc/ld.so.conf || echo /usr/local/lib >> /etc/ld.so.conf
/sbin/ldconfig

xprepare "http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz"
xcheck autoconf
xcheck "./configure --with-curl=/usr/local"
xcheck make
xcheck "make install"

# .gitconfig