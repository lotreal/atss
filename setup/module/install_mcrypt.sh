#!/bin/bash
xprepare $mcrypt
xcheck "/sbin/ldconfig"
xcheck "./configure"
xcheck "make"
xcheck "make install"
