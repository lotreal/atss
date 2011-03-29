#!/bin/bash
/sbin/ldconfig
cd /tmp
[[ -e "git-latest.tar.gz" ]] || wget "http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz"
tar xzvf git-latest.tar.gz
cd git-latest
autoconf
./configure --with-curl=/usr/local
make
make install

# .gitconfig
