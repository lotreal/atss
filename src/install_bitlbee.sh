#!/bin/bash
xprepare $bitlbee
xcheck "./configure --ssl=openssl"
xcheck "make"
xcheck "make install"
xcheck "make install-etc"
